module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state, next_state;

    // State encoding
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        case (state)
            S0: begin
                z = 1'b0;
                if (x == 1'b0)
                    next_state = S0;
                else
                    next_state = S1;
            end
            S1: begin
                z = 1'b0;
                if (x == 1'b0)
                    next_state = S1;
                else
                    next_state = S4;
            end
            S2: begin
                z = 1'b0;
                if (x == 1'b0)
                    next_state = S2;
                else
                    next_state = S1;
            end
            S3: begin
                z = 1'b1;
                if (x == 1'b0)
                    next_state = S1;
                else
                    next_state = S2;
            end
            S4: begin
                z = 1'b1;
                if (x == 1'b0)
                    next_state = S3;
                else
                    next_state = S4;
            end
            default: begin
                z = 1'b0;
                next_state = S0;
            end
        endcase
    end

endmodule