module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] state;
    reg [2:0] next_state;

    // State definitions
    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;
    localparam S5 = 3'd5;
    localparam S6 = 3'd6;
    localparam S7 = 3'd7;

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            
            // Update outputs only when conditions change
            if (state == S5 && !in) disc <= 1;
            else disc <= 0;
            
            if (state == S6 && !in) flag <= 1;
            else flag <= 0;
            
            if (state >= S6 && in) err <= 1;
            else err <= 0;
        end
    end

    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S7 : S0;
            S7: next_state = in ? S7 : S0;
            default: next_state = S0;
        endcase
    end

endmodule