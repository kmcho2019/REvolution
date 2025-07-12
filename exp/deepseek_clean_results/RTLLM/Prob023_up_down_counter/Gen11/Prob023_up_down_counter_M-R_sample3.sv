module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Combinational next state logic
wire [15:0] next_count;

assign next_count = reset ? 16'b0 : 
                   (up_down ? (count + 1'b1) : (count + 16'hFFFF));

// Sequential state update
always @(posedge clk) begin
    count <= next_count;
end

endmodule