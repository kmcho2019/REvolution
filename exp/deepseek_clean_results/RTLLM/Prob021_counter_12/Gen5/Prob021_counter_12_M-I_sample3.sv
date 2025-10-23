module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire gated_clk;
reg [3:0] next_out;

// Clock gating cell
assign gated_clk = clk & (valid_count | ~rst_n);

// Combinational next-state logic
always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end
    else if (valid_count) begin
        next_out = (out[3] & out[1] & out[0]) ? 4'b0000 : out + 1'b1;
    end
    else begin
        next_out = out;
    end
end

// Sequential state storage with gated clock
always @(posedge gated_clk) begin
    out <= next_out;
end

endmodule