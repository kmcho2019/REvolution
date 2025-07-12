module TopModule(
    input clk,
    input d,
    input r,
    output q
);

reg master_q;
reg slave_q;

assign q = slave_q;

always @(posedge clk or posedge r) begin
    if (r) begin
        master_q <= 0;
        slave_q <= 0;
    end else if (clk) begin
        master_q <= d;
    end
end

always @(negedge clk or posedge r) begin
    if (r) begin
        slave_q <= 0;
    end else if (!clk) begin
        slave_q <= master_q;
    end
end

endmodule