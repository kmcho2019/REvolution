module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

reg master_q;

always @(posedge clk) begin
    if (r) begin
        master_q <= 1'b0;
    end else begin
        master_q <= d;
    end
end

always @(negedge clk) begin
    if (r) begin
        q <= 1'b0;
    end else begin
        q <= master_q;
    end
end

endmodule