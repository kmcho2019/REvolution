module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] next_count;

// Combinational logic for next count value
assign next_count = reset ? 16'b0 : 
                   (up_down ? count + 1 : count - 1);

// Sequential logic for registering the count
always @(posedge clk) begin
    count <= next_count;
end

endmodule