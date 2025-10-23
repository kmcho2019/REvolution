module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // One-hot state encoding
    reg [7:0] state;
    parameter [7:0] S0 = 8'b00000001,
                    S1 = 8'b00000010,
                    S2 = 8'b00000100,
                    S3 = 8'b00001000,
                    S4 = 8'b00010000,
                    S5 = 8'b00100000,
                    S6 = 8'b01000000,
                    S7 = 8'b10000000;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            if (in) begin
                case (state)
                    S0: state <= S1;
                    S1: state <= S2;
                    S2: state <= S3;
                    S3: state <= S4;
                    S4: state <= S5;
                    S5: state <= S6;
                    S6: state <= S7;
                    S7: state <= S7; // Stay in error state
                    default: state <= S0;
                endcase
            end else begin
                state <= S0;
            end
        end
    end

    // Output logic - continuous assignments
    assign disc = (state == S5) && !in;
    assign flag = (state == S6) && !in;
    assign err = (state == S7);

endmodule