module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] next_count;
wire carry_out, borrow_out;

// Increment path with carry lookahead for first 4 bits
wire [3:0] inc_low = count[3:0] + 1'b1;
wire inc_carry = &count[3:0];  // Carry when lower 4 bits are all 1s

// Decrement path with borrow lookahead
wire [3:0] dec_low = count[3:0] - 1'b1;
wire dec_borrow = (count[3:0] == 4'b0);  // Borrow when lower 4 bits are 0

// Hybrid next count calculation
assign next_count = up_down ? 
    {count[15:4] + {15'b0, inc_carry}, inc_low} :  // Increment
    {count[15:4] - {15'b0, dec_borrow}, dec_low};  // Decrement

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= next_count;
    end
end

endmodule