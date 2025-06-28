module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
);

always @(*) begin
    for (int i = 0; i < 8; i = i + 1) begin
        if (sel == 1'b0)
            out[i] = a[i];
        else
            out[i] = b[i];
    end
end

endmodule