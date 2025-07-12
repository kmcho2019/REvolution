module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Segment parameters
localparam SEG_WIDTH = 8;
localparam NUM_SEG = 8;

// Input stage registers
reg [63:0] a_reg, b_reg;
reg en_reg;

// Pipeline stage registers
reg [63:0] a_p1, a_p2, a_p3, a_p4, a_p5, a_p6, a_p7, a_p8;
reg [63:0] b_p1, b_p2, b_p3, b_p4, b_p5, b_p6, b_p7, b_p8;
reg [SEG_WIDTH:0] sum_p1, sum_p2, sum_p3, sum_p4, 
                 sum_p5, sum_p6, sum_p7, sum_p8;
reg en_p1, en_p2, en_p3, en_p4, en_p5, en_p6, en_p7, en_p8;

// Carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0;

// Bypass detection
wire inputs_changed = (a_reg != adda) || (b_reg != addb);
wire bypass_active = !inputs_changed && en_reg;

// Segment adders (combinational)
generate
    for (genvar i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        wire [SEG_WIDTH-1:0] a_seg, b_seg;
        wire [SEG_WIDTH:0] seg_sum;
        
        // Select appropriate pipeline stage
        case (i)
            0: begin a_seg = a_reg[7:0];   b_seg = b_reg[7:0];   end
            1: begin a_seg = a_p1[15:8];  b_seg = b_p1[15:8];   end
            2: begin a_seg = a_p2[23:16]; b_seg = b_p2[23:16];  end
            3: begin a_seg = a_p3[31:24]; b_seg = b_p3[31:24];  end
            4: begin a_seg = a_p4[39:32]; b_seg = b_p4[39:32];  end
            5: begin a_seg = a_p5[47:40]; b_seg = b_p5[47:40];  end
            6: begin a_seg = a_p6[55:48]; b_seg = b_p6[55:48];  end
            7: begin a_seg = a_p7[63:56]; b_seg = b_p7[63:56];  end
        endcase
        
        // Carry-select adder segment
        wire [SEG_WIDTH:0] sum0 = {1'b0, a_seg} + {1'b0, b_seg};
        wire [SEG_WIDTH:0] sum1 = sum0 + 1'b1;
        assign seg_sum = carry[i] ? sum1 : sum0;
        assign carry[i+1] = seg_sum[SEG_WIDTH];
        
        // Assign to appropriate pipeline register (combinational)
        always @(*) begin
            case (i)
                0: sum_p1 = seg_sum;
                1: sum_p2 = seg_sum;
                2: sum_p3 = seg_sum;
                3: sum_p4 = seg_sum;
                4: sum_p5 = seg_sum;
                5: sum_p6 = seg_sum;
                6: sum_p7 = seg_sum;
                7: sum_p8 = seg_sum;
            endcase
        end
    end
endgenerate

// Pipeline sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 64'b0; b_reg <= 64'b0; en_reg <= 1'b0;
        a_p1 <= 64'b0; b_p1 <= 64'b0; en_p1 <= 1'b0;
        a_p2 <= 64'b0; b_p2 <= 64'b0; en_p2 <= 1'b0;
        a_p3 <= 64'b0; b_p3 <= 64'b0; en_p3 <= 1'b0;
        a_p4 <= 64'b0; b_p4 <= 64'b0; en_p4 <= 1'b0;
        a_p5 <= 64'b0; b_p5 <= 64'b0; en_p5 <= 1'b0;
        a_p6 <= 64'b0; b_p6 <= 64'b0; en_p6 <= 1'b0;
        a_p7 <= 64'b0; b_p7 <= 64'b0; en_p7 <= 1'b0;
        a_p8 <= 64'b0; b_p8 <= 64'b0; en_p8 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Input stage
        a_reg <= adda;
        b_reg <= addb;
        en_reg <= i_en;
        
        // Pipeline propagation
        if (!bypass_active) begin
            a_p1 <= a_reg; b_p1 <= b_reg; en_p1 <= en_reg;
            a_p2 <= a_p1;  b_p2 <= b_p1;  en_p2 <= en_p1;
            a_p3 <= a_p2;  b_p3 <= b_p2;  en_p3 <= en_p2;
            a_p4 <= a_p3;  b_p4 <= b_p3;  en_p4 <= en_p3;
            a_p5 <= a_p4;  b_p5 <= b_p4;  en_p5 <= en_p4;
            a_p6 <= a_p5;  b_p6 <= b_p5;  en_p6 <= en_p5;
            a_p7 <= a_p6;  b_p7 <= b_p6;  en_p7 <= en_p6;
            a_p8 <= a_p7;  b_p8 <= b_p7;  en_p8 <= en_p7;
        end
        
        // Output stage
        if (en_p8) begin
            result <= {carry[8], 
                      sum_p8[7:0], sum_p7[7:0], sum_p6[7:0], sum_p5[7:0],
                      sum_p4[7:0], sum_p3[7:0], sum_p2[7:0], sum_p1[7:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule