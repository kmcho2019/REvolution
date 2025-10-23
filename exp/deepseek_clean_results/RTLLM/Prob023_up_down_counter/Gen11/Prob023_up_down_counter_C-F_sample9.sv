module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count_gray  // Gray code output
);

// Internal binary counter
reg [15:0] count_bin;

// Segment counters with parallel carry computation
wire [3:0] seg0 = count_bin[3:0];
wire [3:0] seg1 = count_bin[7:4];
wire [3:0] seg2 = count_bin[11:8];
wire [3:0] seg3 = count_bin[15:12];

// Parallel carry computation
wire seg0_max = &seg0;
wire seg1_max = &seg1;
wire seg2_max = &seg2;
wire seg0_min = (seg0 == 4'b0);
wire seg1_min = (seg1 == 4'b0);
wire seg2_min = (seg2 == 4'b0);

always @(posedge clk) begin
    if (reset) begin
        count_bin <= 16'b0;
    end else begin
        if (up_down) begin
            // Increment with parallel carry
            count_bin[3:0] <= seg0 + 1'b1;
            count_bin[7:4] <= seg1 + (seg0_max ? 1'b1 : 1'b0);
            count_bin[11:8] <= seg2 + ((seg0_max & seg1_max) ? 1'b1 : 1'b0);
            count_bin[15:12] <= seg3 + ((seg0_max & seg1_max & seg2_max) ? 1'b1 : 1'b0);
        end else begin
            // Decrement using two's complement trick with parallel borrow
            count_bin[3:0] <= seg0 + 4'b1111;
            count_bin[7:4] <= seg1 + (seg0_min ? 4'b1111 : 4'b0000);
            count_bin[11:8] <= seg2 + ((seg0_min & seg1_min) ? 4'b1111 : 4'b0000);
            count_bin[15:12] <= seg3 + ((seg0_min & seg1_min & seg2_min) ? 4'b1111 : 4'b0000);
        end
    end
end

// Binary to Gray conversion (reduces switching power)
always @(*) begin
    count_gray = count_bin ^ (count_bin >> 1);
end

endmodule