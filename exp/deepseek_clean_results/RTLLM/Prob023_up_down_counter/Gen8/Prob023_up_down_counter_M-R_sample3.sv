module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] count_next;

assign count_next = reset ? 16'b0 : 
                   up_down ? count + 1'b1 : count - 1'b1;

always @(posedge clk) begin
    count <= count_next;
end

endmodule