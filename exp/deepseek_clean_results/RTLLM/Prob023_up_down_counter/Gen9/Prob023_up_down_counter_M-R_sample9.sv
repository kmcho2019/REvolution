module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] next_count;

// Combinational logic for next state
assign next_count = up_down ? count + 1'b1 : count - 1'b1;

// Sequential logic for state update
always @(posedge clk) begin
    if (reset)
        count <= 16'b0;
    else
        count <= next_count;
end

endmodule