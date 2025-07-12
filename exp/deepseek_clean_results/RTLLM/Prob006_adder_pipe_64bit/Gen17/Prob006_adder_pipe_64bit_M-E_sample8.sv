module adder_pipe_64bit #(
    parameter WIDTH = 64,
    parameter SEGMENT = 8,
    parameter DEPTH = WIDTH/SEGMENT
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [WIDTH-1:0] adda,
    input wire [WIDTH-1:0] addb,
    output reg [WIDTH:0] result,
    output reg o_en
);

// Pipeline registers
reg [SEGMENT-1:0] a_seg [DEPTH-1:0];
reg [SEGMENT-1:0] b_seg [DEPTH-1:0];
reg [SEGMENT:0] sum_seg [DEPTH-1:0]; // Includes carry bit
reg [DEPTH-1:0] carry_reg;
reg [DEPTH:0] en_reg; // Extra bit for final stage

// Carry skip logic signals
wire [DEPTH-1:0] carry_skip;
wire [DEPTH-1:0] carry_prop;

// Generate segments
genvar i;
generate
    for (i = 0; i < DEPTH; i = i + 1) begin : SEGMENT_GEN
        // Carry propagation logic
        assign carry_prop[i] = &(a_seg[i] | b_seg[i]);
        
        // Carry skip mux
        assign carry_skip[i] = carry_prop[i] ? carry_reg[i] : sum_seg[i][SEGMENT];
        
        // Segment processing
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_seg[i] <= 0;
                b_seg[i] <= 0;
                sum_seg[i] <= 0;
                carry_reg[i] <= 0;
                en_reg[i] <= 0;
            end else begin
                // Input stage
                if (i == 0) begin
                    a_seg[i] <= adda[SEGMENT-1:0];
                    b_seg[i] <= addb[SEGMENT-1:0];
                    en_reg[i] <= i_en;
                end else begin
                    a_seg[i] <= adda[(i+1)*SEGMENT-1:i*SEGMENT];
                    b_seg[i] <= addb[(i+1)*SEGMENT-1:i*SEGMENT];
                    en_reg[i] <= en_reg[i-1];
                end
                
                // Sum calculation
                if (i == 0)
                    sum_seg[i] <= {1'b0, a_seg[i]} + {1'b0, b_seg[i]};
                else
                    sum_seg[i] <= {1'b0, a_seg[i]} + {1'b0, b_seg[i]} + carry_skip[i-1];
                
                // Carry registration
                if (i < DEPTH-1)
                    carry_reg[i] <= sum_seg[i][SEGMENT];
            end
        end
    end
endgenerate

// Final stage processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
        en_reg[DEPTH] <= 0;
    end else begin
        // Combine all segment results
        result <= {sum_seg[DEPTH-1], 
                  sum_seg[DEPTH-2][SEGMENT-1:0],
                  sum_seg[DEPTH-3][SEGMENT-1:0],
                  sum_seg[DEPTH-4][SEGMENT-1:0],
                  sum_seg[DEPTH-5][SEGMENT-1:0],
                  sum_seg[DEPTH-6][SEGMENT-1:0],
                  sum_seg[DEPTH-7][SEGMENT-1:0],
                  sum_seg[0][SEGMENT-1:0]};
        
        // Final enable propagation
        en_reg[DEPTH] <= en_reg[DEPTH-1];
        o_en <= en_reg[DEPTH];
    end
end

endmodule