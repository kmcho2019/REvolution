module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define the number of bits in each segment
parameter SEG_WIDTH = 16;

// Define the number of segments
parameter NUM_SEG = 64 / SEG_WIDTH;

// Define the width of the carry signal
parameter CARRY_WIDTH = 1;

// Define the width of the input enable signal
parameter EN_WIDTH = 1;

// Internal signals
reg [SEG_WIDTH-1:0] seg_adda [NUM_SEG-1:0];
reg [SEG_WIDTH-1:0] seg_addb [NUM_SEG-1:0];
reg [SEG_WIDTH-1:0] seg_result [NUM_SEG-1:0];
reg [CARRY_WIDTH-1:0] carry [NUM_SEG-1:0];
reg [EN_WIDTH-1:0] en [NUM_SEG-1:0];

// Output register
reg [64:0] out_result;
reg o_en_reg;

// Assign output
assign result = out_result;
assign o_en = o_en_reg;

// Segment adders
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_SEG; i++) begin
            seg_adda[i] <= 16'd0;
            seg_addb[i] <= 16'd0;
            seg_result[i] <= 16'd0;
            carry[i] <= 1'b0;
            en[i] <= 1'b0;
        end
        out_result <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        // Input segmentation
        if (i_en) begin
            seg_adda[0] <= adda[15:0];
            seg_addb[0] <= addb[15:0];
            for (int i = 1; i < NUM_SEG; i++) begin
                seg_adda[i] <= adda[(i*SEG_WIDTH + 15):(i*SEG_WIDTH)];
                seg_addb[i] <= addb[(i*SEG_WIDTH + 15):(i*SEG_WIDTH)];
            end
        end

        // Segment adders and carry propagation
        for (int i = 0; i < NUM_SEG; i++) begin
            if (i == 0) begin
                seg_result[i] <= seg_adda[i] + seg_addb[i];
                carry[i] <= (seg_adda[i][SEG_WIDTH-1] & seg_addb[i][SEG_WIDTH-1]) | ((seg_adda[i][SEG_WIDTH-1] | seg_addb[i][SEG_WIDTH-1]) & (seg_adda[i] + seg_addb[i])[SEG_WIDTH-1]);
            end else begin
                seg_result[i] <= seg_adda[i] + seg_addb[i] + carry[i-1];
                carry[i] <= (seg_adda[i][SEG_WIDTH-1] & seg_addb[i][SEG_WIDTH-1]) | ((seg_adda[i][SEG_WIDTH-1] | seg_addb[i][SEG_WIDTH-1]) & (seg_adda[i] + seg_addb[i] + carry[i-1])[SEG_WIDTH-1]);
            end
        end

        // Output stage
        if (en[NUM_SEG-1]) begin
            out_result <= {carry[NUM_SEG-1], seg_result[NUM_SEG-1]};
            for (int i = NUM_SEG-2; i >= 0; i--) begin
                out_result <= {out_result[64:1], seg_result[i]};
            end
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end

        // Enable signal propagation
        en[0] <= i_en;
        for (int i = 1; i < NUM_SEG; i++) begin
            en[i] <= en[i-1];
        end
    end
end

endmodule