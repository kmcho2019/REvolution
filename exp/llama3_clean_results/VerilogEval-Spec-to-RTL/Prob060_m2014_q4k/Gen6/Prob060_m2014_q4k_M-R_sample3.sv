module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg q0, q1, q2;

always @(posedge clk) begin
    if (!resetn) begin
        q0 <= 1'b0;
    end else begin
        q0 <= in;
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        q1 <= 1'b0;
    end else begin
        q1 <= q0;
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        q2 <= 1'b0;
    end else begin
        q2 <= q1;
    end
end

assign out = q2;

endmodule