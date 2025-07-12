module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

parameter MAX_COUNT = 4'd11;
wire [3:0] next_count;

// Combinational next state logic
assign next_count = (out == MAX_COUNT) ? 4'b0000 : (out + 1'b1);

// Sequential logic with synchronous reset and enable
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end
    else if (valid_count) begin
        out <= next_count;
    end
    // else retain current value
end

endmodule