module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Next count value computation
wire [15:0] next_count = reset ? 16'h0000 : 
                        (up_down ? count + 1'b1 : count - 1'b1);

// Counter update on clock edge
always @(posedge clk) begin
    count <= next_count;
end

endmodule