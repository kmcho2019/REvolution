module counter_12(
    input rst_n,
    input clk,
    input valid_count,
    output reg [3:0] out
);

reg [3:0] next_state;

// Continuous assignment to handle reset
assign next_state = (!rst_n) ? 4'b0000 : (valid_count) ? out + 1 : out;

// Gated clock for power reduction
logic gated_clk;
assign gated_clk = clk & valid_count;

// Sequential logic with gated clock
always @ (posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_state;
    end
end

endmodule