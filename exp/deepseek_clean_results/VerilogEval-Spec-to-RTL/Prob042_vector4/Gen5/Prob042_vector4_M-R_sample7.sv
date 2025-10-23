module TopModule (
    input  [7:0] in,       // 8-bit signed input value
    output reg [31:0] out  // 32-bit sign-extended output
);
    // Sign-extension using procedural assignment
    always @(*) begin
        out = {{24{in[7]}}, in};
    end
endmodule