module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg master_q;

always @(posedge ar or negedge clk) begin
    if (ar) begin
        master_q <= 1'b0;
    end else if (!clk) begin
        master_q <= d;
    end
end

always @(posedge ar or posedge clk) begin
    if (ar) begin
        q <= 1'b0;
    end else if (clk) begin
        q <= master_q;
    end
end

endmodule