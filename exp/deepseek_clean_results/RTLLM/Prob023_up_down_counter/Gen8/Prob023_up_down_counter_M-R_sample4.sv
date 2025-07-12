module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count = 0  // Initialize to 0
);

// Combinational next state logic
wire [15:0] next_count = up_down ? (count + 1) : (count - 1);

// Sequential logic
always @(posedge clk) begin
    count <= reset ? 16'b0 : next_count;
end

endmodule