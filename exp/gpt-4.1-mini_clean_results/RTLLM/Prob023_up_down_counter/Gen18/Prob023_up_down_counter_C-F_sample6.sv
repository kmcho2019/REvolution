module up_down_counter (
    input  wire        clk,
    input  wire        reset,
    input  wire        up_down,
    output reg [15:0]  count
);

// Separate increment and decrement calculation
wire [15:0] count_inc = count + 16'd1;
wire [15:0] count_dec = count - 16'd1;

// Select next count based on up_down signal
wire [15:0] next_count = up_down ? count_inc : count_dec;

always @(posedge clk) begin
    if (reset)
        count <= 16'd0;
    else
        count <= next_count;
end

endmodule