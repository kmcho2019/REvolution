module TopModule (
    input  wire clk,
    input  wire d,
    input  wire r,
    output wire q
);

reg q_int;

always @(posedge clk) begin
    if (r)
        q_int <= 1'b0;
    else
        q_int <= d;
end

assign q = q_int;

endmodule