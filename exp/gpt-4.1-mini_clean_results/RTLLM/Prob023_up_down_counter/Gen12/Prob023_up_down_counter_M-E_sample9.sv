module up_down_counter (
    input wire clk,
    input wire reset,     // asynchronous reset, active high
    input wire up_down,
    output reg [15:0] count
);

// Next state calculation
wire [15:0] count_inc;
wire [15:0] count_dec;
wire [15:0] next_count;

assign count_inc = count + 16'd1;
assign count_dec = count - 16'd1;

assign next_count = up_down ? count_inc : count_dec;

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 16'd0;
    else
        count <= next_count;
end

endmodule