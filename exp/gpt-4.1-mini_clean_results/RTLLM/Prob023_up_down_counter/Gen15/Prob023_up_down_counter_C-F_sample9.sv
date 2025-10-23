module up_down_counter (
    input  wire        clk,
    input  wire        reset,    // synchronous reset, active high
    input  wire        up_down,
    output reg [15:0]  count
);

// Compute incremented and decremented count values
wire [15:0] count_inc = count + 16'd1;
wire [15:0] count_dec = count - 16'd1;

// Select next count based on up_down
wire [15:0] next_count = up_down ? count_inc : count_dec;

// Enable counting only when reset is asserted or up_down input changes or to reduce unnecessary toggling (optional for power saving)
reg up_down_d;
wire count_enable = reset || (up_down != up_down_d);

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else if (count_enable) begin
        count <= next_count;
    end
    // else hold current count
    up_down_d <= up_down;
end

endmodule