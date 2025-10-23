module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Segmentation Controller
reg [1:0] seg_cnt;
reg [7:0] a_seg, b_seg;

always @(posedge clk) begin
    if (rst) begin
        seg_cnt <= 2'd0;
    end else if (seg_cnt == 2'd3) begin
        seg_cnt <= 2'd0;
    end else begin
        seg_cnt <= seg_cnt + 1'd1;
    end
end

always @(posedge clk) begin
    case (seg_cnt)
        2'd0: begin
            a_seg <= a[7:0];
            b_seg <= b[7:0];
        end
        2'd1: begin
            a_seg <= a[15:8];
            b_seg <= b[15:8];
        end
        2'd2: begin
            a_seg <= a[23:16];
            b_seg <= b[23:16];
        end
        2'd3: begin
            a_seg <= a[31:24];
            b_seg <= b[31:24];
        end
    endcase
end

// Programmable Multiplier
wire [15:0] mult;

assign mult = a_seg * b_seg;

// Accumulator
reg [31:0] c_reg;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        case (seg_cnt)
            2'd0: begin
                c_reg <= c_reg + {24'd0, mult};
            end
            2'd1: begin
                c_reg <= c_reg + {16'd0, mult, 8'd0};
            end
            2'd2: begin
                c_reg <= c_reg + {8'd0, mult, 16'd0};
            end
            2'd3: begin
                c_reg <= c_reg + {mult, 24'd0};
            end
        endcase
    end
end

// Output Assignment
assign c = c_reg;

endmodule