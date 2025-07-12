module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Segment counters
reg [3:0] seg0, seg1, seg2, seg3;
wire seg0_carry, seg1_carry, seg2_carry;

// Segment 0 (LSB)
always @(posedge clk) begin
    if (reset) begin
        seg0 <= 4'b0;
    end else begin
        if (up_down) seg0 <= seg0 + 1'b1;
        else seg0 <= seg0 - 1'b1;
    end
end

assign seg0_carry = up_down ? (&seg0) : (seg0 == 4'b0);

// Segment 1
always @(posedge clk) begin
    if (reset) begin
        seg1 <= 4'b0;
    end else if (seg0_carry) begin
        if (up_down) seg1 <= seg1 + 1'b1;
        else seg1 <= seg1 - 1'b1;
    end
end

assign seg1_carry = up_down ? (&seg1) : (seg1 == 4'b0);

// Segment 2
always @(posedge clk) begin
    if (reset) begin
        seg2 <= 4'b0;
    end else if (seg0_carry && seg1_carry) begin
        if (up_down) seg2 <= seg2 + 1'b1;
        else seg2 <= seg2 - 1'b1;
    end
end

assign seg2_carry = up_down ? (&seg2) : (seg2 == 4'b0);

// Segment 3 (MSB)
always @(posedge clk) begin
    if (reset) begin
        seg3 <= 4'b0;
    end else if (seg0_carry && seg1_carry && seg2_carry) begin
        if (up_down) seg3 <= seg3 + 1'b1;
        else seg3 <= seg3 - 1'b1;
    end
end

// Combine segments
always @(*) begin
    count = {seg3, seg2, seg1, seg0};
end

endmodule