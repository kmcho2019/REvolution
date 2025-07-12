module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_int;

always @(posedge clk or negedge clk) begin
    if (clk) begin
        q_int <= d;
    end else begin
        q_int <= d;
    end
end

assign q = q_int;

endmodule