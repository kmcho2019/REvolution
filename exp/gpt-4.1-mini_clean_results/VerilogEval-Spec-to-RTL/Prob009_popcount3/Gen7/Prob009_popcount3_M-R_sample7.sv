module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    reg [2:0] bit_count;

    // Combinational always block to count set bits
    always @(*) begin
        bit_count = in[0] + in[1] + in[2];
    end

    // Assign the lower two bits of bit_count to output
    assign out = bit_count[1:0];

endmodule