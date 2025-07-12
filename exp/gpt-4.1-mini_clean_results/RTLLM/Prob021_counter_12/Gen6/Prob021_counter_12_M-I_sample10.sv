module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

reg [3:0] next_count;
wire count_enable = valid_count;

// Combinational logic for next count calculation
always @(*) begin
    if (count_enable) begin
        if (out == 4'd11)
            next_count = 4'b0000;
        else
            next_count = out + 1;
    end else begin
        next_count = out;
    end
end

// Sequential logic with clock enable to reduce switching
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (count_enable)
        out <= next_count;
    else
        out <= out; // hold value
end

endmodule