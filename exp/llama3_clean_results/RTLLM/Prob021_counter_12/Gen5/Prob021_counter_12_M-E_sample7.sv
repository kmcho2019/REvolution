module counter_12 (
    input   rst_n,
    input   clk,
    input   valid_count,
    output reg [3:0] out
);

reg [3:0] count;

always @(posedge clk) begin
    if (!rst_n) begin
        count <= 4'b0000;
    end else if (valid_count) begin
        if (count == 4'd11) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= count;
    end
end

endmodule