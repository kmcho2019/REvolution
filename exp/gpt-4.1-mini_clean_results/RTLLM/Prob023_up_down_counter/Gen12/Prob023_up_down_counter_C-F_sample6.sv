module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up_down,
    output reg [15:0] count
);

reg [15:0] next_count;

// Combinational logic to determine next count value based on up_down control
always @(*) begin
    if (up_down)
        next_count = count + 16'd1;
    else
        next_count = count - 16'd1;
end

// Sequential logic: synchronous reset and count update on rising clock edge
always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= next_count;
end

endmodule