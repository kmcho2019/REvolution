module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

    // Registered output with continuous assignment for clean timing
    always @(*) begin
        out = sel ? b : a;
    end

endmodule