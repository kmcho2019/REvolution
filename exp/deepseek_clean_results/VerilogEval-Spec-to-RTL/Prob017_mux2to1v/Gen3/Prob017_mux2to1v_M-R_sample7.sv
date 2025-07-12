module TopModule (
    input  [99:0] a,    // 100-bit input A
    input  [99:0] b,    // 100-bit input B
    input         sel,  // Selection signal (0: select A, 1: select B)
    output reg [99:0] out   // 100-bit registered output
);

    // 100-bit 2:1 multiplexer using case statement
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 100'bx; // Handle undefined sel (good practice)
        endcase
    end

endmodule