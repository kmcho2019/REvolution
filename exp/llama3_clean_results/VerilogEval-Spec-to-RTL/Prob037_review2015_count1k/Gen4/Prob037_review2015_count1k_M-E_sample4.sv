module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [2:0] lower_bits;
reg [6:0] higher_bits;
reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        lower_bits <= 3'd0;
        higher_bits <= 7'd0;
    end else if (lower_bits == 3'd7) begin
        lower_bits <= 3'd0;
        if (higher_bits == 7'd127) begin
            higher_bits <= 7'd0;
        end else begin
            higher_bits <= higher_bits + 7'd1;
        end
    end else begin
        lower_bits <= lower_bits + 3'd1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        count <= 10'd0;
    end else begin
        count <= {higher_bits, lower_bits};
    end
end

assign q = count;

endmodule