module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation Unit
wire [15:0] a_seg1, a_seg2;
wire [15:0] b_seg1, b_seg2;

assign a_seg1 = a[15:0];
assign a_seg2 = a[31:16];
assign b_seg1 = b[15:0];
assign b_seg2 = b[31:16];

// Time-Multiplexed Multiplier
reg [31:0] multiplier_out;
reg [1:0] segment_select;

always @(posedge clk) begin
    case (segment_select)
        2'b00: multiplier_out <= a_seg1 * b_seg1;
        2'b01: multiplier_out <= a_seg1 * b_seg2;
        2'b10: multiplier_out <= a_seg2 * b_seg1;
        2'b11: multiplier_out <= a_seg2 * b_seg2;
    endcase
end

// Accumulator and Buffering
reg [31:0] c_reg;
reg [31:0] buffer1, buffer2, buffer3, buffer4;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
        buffer1 <= 32'd0;
        buffer2 <= 32'd0;
        buffer3 <= 32'd0;
        buffer4 <= 32'd0;
    end else begin
        case (segment_select)
            2'b00: buffer1 <= multiplier_out;
            2'b01: buffer2 <= multiplier_out;
            2'b10: buffer3 <= multiplier_out;
            2'b11: buffer4 <= multiplier_out;
        endcase
        
        if (segment_select == 2'b11) begin
            c_reg <= buffer1 + buffer2 + buffer3 + buffer4;
        end
    end
end

// Control Unit
always @(posedge clk) begin
    if (rst) begin
        segment_select <= 2'b00;
    end else begin
        case (segment_select)
            2'b00: segment_select <= 2'b01;
            2'b01: segment_select <= 2'b10;
            2'b10: segment_select <= 2'b11;
            2'b11: segment_select <= 2'b00;
        endcase
    end
end

// Output Assignment
assign c = c_reg;

endmodule