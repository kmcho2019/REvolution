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

// Time-Multiplexed Multiplication
reg [1:0] state;
wire [15:0] mult;

always @(posedge clk) begin
    if (rst) begin
        state <= 2'd0;
    end else begin
        case (state)
            2'd0: begin
                mult <= a_seg1 * b_seg1;
                state <= 2'd1;
            end
            2'd1: begin
                mult <= a_seg2 * b_seg2;
                state <= 2'd2;
            end
            2'd2: begin
                mult <= a_seg3 * b_seg3;
                state <= 2'd3;
            end
            2'd3: begin
                mult <= a_seg4 * b_seg4;
                state <= 2'd0;
            end
        endcase
    end
end

// Accumulator
reg [31:0] c_reg;
reg [1:0] shift;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
        shift <= 2'd0;
    end else begin
        case (state)
            2'd0: begin
                c_reg <= c_reg + (mult);
                shift <= 2'd0;
            end
            2'd1: begin
                c_reg <= c_reg + (mult << 8);
                shift <= 2'd1;
            end
            2'd2: begin
                c_reg <= c_reg + (mult << 16);
                shift <= 2'd2;
            end
            2'd3: begin
                c_reg <= c_reg + (mult << 24);
                shift <= 2'd3;
            end
        endcase
    end
end

// Output Assignment
assign c = c_reg;

endmodule