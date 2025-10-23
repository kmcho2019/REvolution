module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_SEG = DATA_WIDTH / STG_WIDTH;

// Input registers
reg [DATA_WIDTH-1:0] a_reg, b_reg;
reg input_en_reg;

// Pipeline registers
reg [DATA_WIDTH-1:0] a_pipe [0:NUM_SEG];
reg [DATA_WIDTH-1:0] b_pipe [0:NUM_SEG];
reg [STG_WIDTH:0] sum_pipe [0:NUM_SEG]; // +1 bit for carry
reg [NUM_SEG:0] en_pipe;

// Segment carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0;

// Clock gating
wire clk_en = i_en || (|en_pipe);
wire gated_clk = clk & clk_en;

// Generate segments with carry-lookahead
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        wire [STG_WIDTH-1:0] a_seg = a_pipe[i][(i+1)*STG_WIDTH-1:i*STG_WIDTH];
        wire [STG_WIDTH-1:0] b_seg = b_pipe[i][(i+1)*STG_WIDTH-1:i*STG_WIDTH];
        
        // Carry-lookahead logic
        wire [STG_WIDTH:0] p = {1'b0, a_seg | b_seg};
        wire [STG_WIDTH:0] g = {1'b0, a_seg & b_seg};
        wire [STG_WIDTH:0] c;
        
        assign c[0] = carry[i];
        for (genvar j = 1; j <= STG_WIDTH; j = j + 1) begin
            assign c[j] = g[j-1] | (p[j-1] & c[j-1]);
        end
        
        // Sum calculation
        wire [STG_WIDTH-1:0] seg_sum = a_seg ^ b_seg ^ c[STG_WIDTH-1:0];
        
        // Propagate carry to next segment
        assign carry[i+1] = c[STG_WIDTH];
        
        always @(posedge gated_clk or negedge rst_n) begin
            if (!rst_n) begin
                a_pipe[i+1] <= {DATA_WIDTH{1'b0}};
                b_pipe[i+1] <= {DATA_WIDTH{1'b0}};
                sum_pipe[i+1] <= {(STG_WIDTH+1){1'b0}};
            end else if (en_pipe[i]) begin
                a_pipe[i+1] <= a_pipe[i];
                b_pipe[i+1] <= b_pipe[i];
                sum_pipe[i+1] <= {carry[i+1], seg_sum};
            end
        end
    end
endgenerate

// Pipeline control
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= {DATA_WIDTH{1'b0}};
        b_reg <= {DATA_WIDTH{1'b0}};
        input_en_reg <= 1'b0;
        en_pipe <= {(NUM_SEG+1){1'b0}};
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Input stage
        a_reg <= adda;
        b_reg <= addb;
        input_en_reg <= i_en;
        
        // Pipeline registers
        a_pipe[0] <= a_reg;
        b_pipe[0] <= b_reg;
        en_pipe[0] <= input_en_reg;
        
        // Shift enable through pipeline
        for (int j = 1; j <= NUM_SEG; j = j + 1) begin
            en_pipe[j] <= en_pipe[j-1];
        end
        
        // Output stage
        if (en_pipe[NUM_SEG]) begin
            // Combine segment sums
            case (NUM_SEG)
                4: result <= {
                    sum_pipe[4][STG_WIDTH],
                    sum_pipe[3][STG_WIDTH-1:0],
                    sum_pipe[2][STG_WIDTH-1:0],
                    sum_pipe[1][STG_WIDTH-1:0],
                    sum_pipe[0][STG_WIDTH-1:0]
                };
                default: result <= {(DATA_WIDTH+1){1'b0}};
            endcase
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule