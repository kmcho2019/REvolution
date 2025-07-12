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
    parameter S0 = 8'b00000001;
    parameter S1 = 8'b00000010;
    parameter S2 = 8'b00000100;
    parameter S3 = 8'b00001000;
    parameter S4 = 8'b00010000;
    parameter S5 = 8'b00100000;
    parameter S6 = 8'b01000000;
    parameter S7 = 8'b10000000;

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            if (in) begin
                case (1'b1) // synthesis parallel_case
                    state[0]: state <= S1;
                    state[1]: state <= S2;
                    state[2]: state <= S3;
                    state[3]: state <= S4;
                    state[4]: state <= S5;
                    state[5]: state <= S6;
                    state[6]: state <= S7;
                    state[7]: state <= S7;
                    default: state <= S0;
                endcase
            end else begin
                state <= S0;
            end
        end
    end

    // Output logic - combinational
    assign disc = (state == S5) && ~in;
    assign flag = (state == S6) && ~in;
    assign err  = (state == S6) && in;

endmodule