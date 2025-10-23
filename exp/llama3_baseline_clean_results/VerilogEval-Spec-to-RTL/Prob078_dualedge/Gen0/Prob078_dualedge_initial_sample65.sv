module TopModule(
    input clk,
    input d,
    output q
);

reg internal_clk;
reg q_int;

always @(posedge clk) begin
    internal_clk <= ~internal_clk;
    if(internal_clk) begin
        q_int <= d;
    end
end

always @(negedge clk) begin
    if(~internal_clk) begin
        q_int <= d;
    end
end

assign q = q_int;

endmodule