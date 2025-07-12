module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] xor_bits;
    wire enable;

    assign xor_bits = in ^ prev_in;
    assign enable = |xor_bits; // Enable register update only when any bit changed

    always @(posedge clk) begin
        prev_in <= in;
        if (enable)
            anyedge <= xor_bits;
        else
            anyedge <= anyedge; // hold previous value to avoid toggling
    end
endmodule