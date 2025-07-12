module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

    always @(*) begin
        if (c == 4'd0) q = b;
        else if (c == 4'd1) q = e;
        else if (c == 4'd2) q = a;
        else if (c == 4'd3) q = d;
        else q = {4{1'b1}}; // default to all ones for other values of c
    end

endmodule