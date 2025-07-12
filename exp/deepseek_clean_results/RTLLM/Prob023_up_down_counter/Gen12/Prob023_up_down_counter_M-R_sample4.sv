module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] next_count;

// Combinational logic for next state
assign next_count = reset ? 16'h0000 : 
                   (up_down ? (count + 1'b1) : (count - 1'b1);

// Sequential element for current state
always @(posedge clk) begin
    count <= next_count;
end

endmodule