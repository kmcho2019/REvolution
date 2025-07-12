module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg bit0, bit1, bit2, bit3;

always @(posedge clk) begin
    if (!resetn) begin
        bit0 <= 1'b0;
    end else begin
        bit0 <= in;
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        bit1 <= 1'b0;
    end else begin
        bit1 <= bit0;
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        bit2 <= 1'b0;
    end else begin
        bit2 <= bit1;
    end
end

always @(posedge clk) begin
    if (!resetn) begin
        bit3 <= 1'b0;
    end else begin
        bit3 <= bit2;
    end
end

assign out = bit3;

endmodule