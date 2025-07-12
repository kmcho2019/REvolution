module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

reg [3:0] next_state;

assign next_state = (!rst_n) ? 4'b0000 : (valid_count && out == 4'd11) ? 4'b0000 : (valid_count) ? out + 1 : out;

always @ (posedge clk) begin
    out <= next_state;
end

endmodule