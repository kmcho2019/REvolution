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

// Next value computation for each segment
reg [3:0] next_seg0, next_seg1, next_seg2, next_seg3;
reg carry0, carry1, carry2;

always @(*) begin
    // Segment 0 (LSB) always updates
    if (up_down) begin
        {carry0, next_seg0} = seg0 + 1'b1;
    end else begin
        {carry0, next_seg0} = seg0 - 1'b1;
    end

    // Segment 1 updates only if segment 0 wraps
    if (carry0) begin
        if (up_down) begin
            {carry1, next_seg1} = seg1 + 1'b1;
        end else begin
            {carry1, next_seg1} = seg1 - 1'b1;
        end
    end else begin
        next_seg1 = seg1;
        carry1 = 1'b0;
    end

    // Segment 2 updates only if segment 1 wraps
    if (carry1) begin
        if (up_down) begin
            {carry2, next_seg2} = seg2 + 1'b1;
        end else begin
            {carry2, next_seg2} = seg2 - 1'b1;
        end
    end else begin
        next_seg2 = seg2;
        carry2 = 1'b0;
    end

    // Segment 3 (MSB) updates only if segment 2 wraps
    if (carry2) begin
        if (up_down) begin
            next_seg3 = seg3 + 1'b1;
        end else begin
            next_seg3 = seg3 - 1'b1;
        end
    end else begin
        next_seg3 = seg3;
    end
end

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= {next_seg3, next_seg2, next_seg1, next_seg0};
    end
end

endmodule