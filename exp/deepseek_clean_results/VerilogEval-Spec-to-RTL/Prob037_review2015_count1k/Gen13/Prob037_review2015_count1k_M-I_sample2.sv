module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg terminal_count;
reg [4:0] upper_bits;
reg [4:0] lower_bits;

// Break comparison into two stages
always @(posedge clk) begin
    upper_bits <= q[9:5];
    lower_bits <= q[4:0];
    terminal_count <= (upper_bits == 5'b11111) && (lower_bits == 5'b00111); // 999 = 1111100111
end

// Clock gating logic
reg clk_en;
always @(posedge clk) begin
    if (reset) begin
        clk_en <= 1'b1;
    end else if (terminal_count) begin
        clk_en <= 1'b0;
    end else begin
        clk_en <= 1'b1;
    end
end

// Counter logic with gated clock
always @(posedge clk) begin
    if (reset) begin
        q <= 10'b0;
    end else if (clk_en) begin
        q <= (terminal_count) ? 10'b0 : q + 1'b1;
    end
end

endmodule