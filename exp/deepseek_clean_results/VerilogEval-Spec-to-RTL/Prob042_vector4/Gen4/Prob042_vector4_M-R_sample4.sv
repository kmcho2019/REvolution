module TopModule (
    input  [7:0] in,       // 8-bit signed input
    output reg [31:0] out  // 32-bit sign-extended output
);
    always @(*) begin
        case (in[7])
            1'b0: out = {24'b0, in};    // Positive number - extend with 0s
            1'b1: out = {24'hFFFFFF, in}; // Negative number - extend with 1s
        endcase
    end
endmodule