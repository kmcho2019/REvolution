module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

parameter MAX_COUNT = 4'd11;
wire [3:0] next_out;

// Combinational next state logic
assign next_out = (!rst_n) ? 4'b0000 :
                 (valid_count) ? ((out == MAX_COUNT) ? 4'b0000 : out + 1'b1) :
                 out;

// Sequential state update
always @(posedge clk) begin
    out <= next_out;
end

endmodule