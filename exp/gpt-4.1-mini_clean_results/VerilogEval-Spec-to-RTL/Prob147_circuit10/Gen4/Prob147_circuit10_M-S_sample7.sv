module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        state <= a ^ b ^ state;  // next state is XOR of inputs and current state
        q <= a ^ b ^ state;      // output q follows the next state value
    end

endmodule