module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);
    // Sign-extend 8-bit input to 32 bits by replicating the sign bit (MSB) 24 times
    always @(*) begin
        out = { {24{in[7]}}, in };
    end
endmodule