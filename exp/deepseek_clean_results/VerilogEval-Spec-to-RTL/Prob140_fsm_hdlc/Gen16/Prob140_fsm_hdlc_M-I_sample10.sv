module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Gray-coded state encoding for reduced switching
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b011;
    localparam S3 = 3'b010;
    localparam S4 = 3'b110;
    localparam S5 = 3'b111;
    localparam S6 = 3'b101;  // Handles both 6+ 1s and error condition

    reg [2:0] state, next_state;
    reg next_err;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
            next_err <= 0;
        end else begin
            state <= next_state;
            next_err <= (state == S6) || ((state == S5) && in);
            
            // Registered outputs
            disc <= (state == S5) && !in;
            flag <= (state == S6) && !in;
            err <= next_err;
        end
    end

    // Next state logic with Gray coding transitions
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S6 : S0;  // Stay in error state until 0
        endcase
    end

endmodule