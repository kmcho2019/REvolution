module TopModule (
    input clk,
    input in,
    output reg out
);

    reg in_d;      // delayed version of input 'in'
    reg xor_val;   // intermediate XOR value

    always @(posedge clk) begin
        in_d <= in;           // stage 1: capture input
        xor_val <= in_d ^ out; // stage 2: XOR delayed input and current output
        out <= xor_val;        // stage 3: update output
    end

endmodule