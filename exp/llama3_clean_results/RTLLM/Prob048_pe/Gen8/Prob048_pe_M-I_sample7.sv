module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation
wire [7:0] a_seg1, a_seg2, a_seg3, a_seg4;
wire [7:0] b_seg1, b_seg2, b_seg3, b_seg4;

assign a_seg1 = a[7:0];
assign a_seg2 = a[15:8];
assign a_seg3 = a[23:16];
assign a_seg4 = a[31:24];

assign b_seg1 = b[7:0];
assign b_seg2 = b[15:8];
assign b_seg3 = b[23:16];
assign b_seg4 = b[31:24];

// Multiplier
reg [15:0] mult_reg;
wire [15:0] mult_in;
reg [1:0] mult_state;

always @(posedge clk) begin
    if (rst) begin
        mult_state <= 2'b00;
        mult_reg <= 16'd0;
    end else begin
        case (mult_state)
            2'b00: begin
                mult_in = a_seg1 * b_seg1;
                mult_state <= 2'b01;
            end
            2'b01: begin
                mult_in = a_seg2 * b_seg2;
                mult_state <= 2'b10;
            end
            2'b10: begin
                mult_in = a_seg3 * b_seg3;
                mult_state <= 2'b11;
            end
            2'b11: begin
                mult_in = a_seg4 * b_seg4;
                mult_state <= 2'b00;
            end
        endcase
        mult_reg <= mult_in;
    end
end

// Accumulator
reg [31:0] c_reg;
wire [31:0] add_result;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        case (mult_state)
            2'b00: begin
                add_result = c_reg + (mult_reg << 0);
            end
            2'b01: begin
                add_result = c_reg + (mult_reg << 8);
            end
            2'b10: begin
                add_result = c_reg + (mult_reg << 16);
            end
            2'b11: begin
                add_result = c_reg + (mult_reg << 24);
            end
        endcase
        c_reg <= add_result;
    end
end

// Output Assignment
assign c = c_reg;

endmodule