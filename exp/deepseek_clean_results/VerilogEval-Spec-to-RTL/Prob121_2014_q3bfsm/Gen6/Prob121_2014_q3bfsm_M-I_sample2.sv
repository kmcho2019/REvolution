module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // One-hot state encoding
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        next_state = 5'b0;
        case (1'b1) // synthesis parallel_case
            state[S0]: next_state = x ? S1 : S0;
            state[S1]: next_state = x ? S4 : S1;
            state[S2]: next_state = x ? S1 : S2;
            state[S3]: next_state = x ? S2 : S1;
            state[S4]: next_state = x ? S4 : S3;
        endcase
    end

    // Sequential state update and output registration
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule