module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Constants
localparam SEG_WIDTH = 8;
localparam NUM_SEG = 8;

// Pipeline registers
reg [SEG_WIDTH-1:0] a_seg [NUM_SEG-1:0];
reg [SEG_WIDTH-1:0] b_seg [NUM_SEG-1:0];
reg [SEG_WIDTH:0] sum_seg [NUM_SEG-1:0]; // Includes carry bit
reg [NUM_SEG:0] en_reg; // Enable pipeline

// Carry propagation
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0;

genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENT_GEN
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_seg[i] <= 0;
                b_seg[i] <= 0;
                sum_seg[i] <= 0;
                en_reg[i] <= 0;
            end else begin
                // Input stage
                if (i == 0) begin
                    a_seg[i] <= adda[SEG_WIDTH-1:0];
                    b_seg[i] <= addb[SEG_WIDTH-1:0];
                    en_reg[i] <= i_en;
                end else begin
                    a_seg[i] <= adda[(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
                    b_seg[i] <= addb[(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
                    en_reg[i] <= en_reg[i-1];
                end
                
                // Sum calculation with carry
                sum_seg[i] <= {1'b0, a_seg[i]} + {1'b0, b_seg[i]} + carry[i];
            end
        end
        
        // Carry propagation
        assign carry[i+1] = sum_seg[i][SEG_WIDTH];
    end
endgenerate

// Final output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
        en_reg[NUM_SEG] <= 0;
    end else begin
        // Combine all segment results
        result <= {sum_seg[7], sum_seg[6][SEG_WIDTH-1:0],
                  sum_seg[5][SEG_WIDTH-1:0], sum_seg[4][SEG_WIDTH-1:0],
                  sum_seg[3][SEG_WIDTH-1:0], sum_seg[2][SEG_WIDTH-1:0],
                  sum_seg[1][SEG_WIDTH-1:0], sum_seg[0][SEG_WIDTH-1:0]};
        
        // Output enable
        en_reg[NUM_SEG] <= en_reg[NUM_SEG-1];
        o_en <= en_reg[NUM_SEG];
    end
end

endmodule