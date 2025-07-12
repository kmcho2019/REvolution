module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define parameters
parameter SEGMENT_WIDTH = 8;
parameter NUM_SEGMENTS = 64 / SEGMENT_WIDTH;

// Define wires and registers
wire [SEGMENT_WIDTH-1:0] partial_sums [NUM_SEGMENTS-1:0];
wire carry_out [NUM_SEGMENTS-1:0];
reg [SEGMENT_WIDTH-1:0] segment_regs [NUM_SEGMENTS-1:0];
reg [SEGMENT_WIDTH-1:0] adda_regs [NUM_SEGMENTS-1:0];
reg [SEGMENT_WIDTH-1:0] addb_regs [NUM_SEGMENTS-1:0];
reg [64:0] result_reg;

// Segmentation and parallel addition
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            adda_regs[i] <= 8'd0;
            addb_regs[i] <= 8'd0;
        end
    end else if (i_en) begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            adda_regs[i] <= adda[(i*SEGMENT_WIDTH)+:SEGMENT_WIDTH];
            addb_regs[i] <= addb[(i*SEGMENT_WIDTH)+:SEGMENT_WIDTH];
        end
    end
end

// Pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            segment_regs[i] <= 8'd0;
        end
        result_reg <= 65'd0;
    end else begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            if (i == 0) begin
                segment_regs[i] <= adda_regs[i] + addb_regs[i];
            end else begin
                segment_regs[i] <= adda_regs[i] + addb_regs[i] + carry_out[i-1];
            end
            carry_out[i] <= (adda_regs[i][SEGMENT_WIDTH-1] & addb_regs[i][SEGMENT_WIDTH-1]) | (adda_regs[i][SEGMENT_WIDTH-1] & segment_regs[i][SEGMENT_WIDTH-1]) | (addb_regs[i][SEGMENT_WIDTH-1] & segment_regs[i][SEGMENT_WIDTH-1]);
        end
        result_reg <= {carry_out[NUM_SEGMENTS-1], segment_regs};
    end
end

// Result combination and output
assign result = result_reg;
assign o_en = (result_reg[64] == 1'b1);

endmodule