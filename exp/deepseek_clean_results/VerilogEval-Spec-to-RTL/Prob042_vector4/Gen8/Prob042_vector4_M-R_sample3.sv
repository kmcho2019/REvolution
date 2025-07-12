module TopModule (
    input [7:0] in,
    output reg [31:0] out
);
    always @(*) begin
        out[31:8] = {24{in[7]}};  // Replicate sign bit 24 times
        out[7:0]  = in;            // Copy original 8 bits
    end
endmodule