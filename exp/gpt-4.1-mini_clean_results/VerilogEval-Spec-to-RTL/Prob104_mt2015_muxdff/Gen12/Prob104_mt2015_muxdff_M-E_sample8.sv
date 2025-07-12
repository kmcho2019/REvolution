module TopModule (
    input  clk,
    input  L,
    input  r_in,
    input  xor_in1,
    input  xor_in2,
    output reg Q
);

    wire next_bit = xor_in1 ^ xor_in2;

    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;
        end else begin
            Q <= next_bit;
        end
    end

endmodule