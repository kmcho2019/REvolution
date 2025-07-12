module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Segment the counter into 4 nibbles
wire [3:0] seg0 = count[3:0];
wire [3:0] seg1 = count[7:4];
wire [3:0] seg2 = count[11:8];
wire [3:0] seg3 = count[15:12];

// Next value computation using continuous assignments
wire [4:0] seg0_next = up_down ? {1'b0, seg0} + 5'd1 : {1'b0, seg0} - 5'd1;
wire seg0_carry = seg0_next[4];

wire [4:0] seg1_next = (seg0_carry) ? 
                      (up_down ? {1'b0, seg1} + 5'd1 : {1'b0, seg1} - 5'd1) : 
                      {1'b0, seg1};
wire seg1_carry = seg1_next[4];

wire [4:0] seg2_next = (seg1_carry) ? 
                      (up_down ? {1'b0, seg2} + 5'd1 : {1'b0, seg2} - 5'd1) : 
                      {1'b0, seg2};
wire seg2_carry = seg2_next[4];

wire [3:0] seg3_next = (seg2_carry) ? 
                      (up_down ? seg3 + 4'd1 : seg3 - 4'd1) : 
                      seg3;

// Combine next values
wire [15:0] next_count = {seg3_next, seg2_next[3:0], seg1_next[3:0], seg0_next[3:0]};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule