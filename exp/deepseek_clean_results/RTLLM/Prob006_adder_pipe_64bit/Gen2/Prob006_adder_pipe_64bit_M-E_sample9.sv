module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

parameter SEG_WIDTH = 8;    // Bits per segment
parameter NUM_SEGS = 8;     // 64/8 = 8 segments

// Pipeline stage 1 registers - precompute both sum possibilities
reg [SEG_WIDTH:0] sum0 [0:NUM_SEGS-1];  // Sum assuming carry-in=0
reg [SEG_WIDTH:0] sum1 [0:NUM_SEGS-1];  // Sum assuming carry-in=1
reg [63:0] adda_p1, addb_p1;
reg en_p1;

// Pipeline stage 2 registers - carry propagation and sum selection
reg [SEG_WIDTH-1:0] selected_sum [0:NUM_SEGS-1];
reg carry [0:NUM_SEGS];
reg en_p2;

// Pipeline stage 3 registers - result assembly
reg [64:0] result_p3;
reg en_p3;

// Combinational logic for segment additions
genvar i;
generate
    for (i = 0; i < NUM_SEGS; i = i + 1) begin : segment_adders
        // Compute both possible sums for each segment
        always @(*) begin
            sum0[i] = {1'b0, adda_p1[i*SEG_WIDTH +: SEG_WIDTH]} + 
                      {1'b0, addb_p1[i*SEG_WIDTH +: SEG_WIDTH]};
            sum1[i] = {1'b0, adda_p1[i*SEG_WIDTH +: SEG_WIDTH]} + 
                      {1'b0, addb_p1[i*SEG_WIDTH +: SEG_WIDTH]} + 1'b1;
        end
    end
endgenerate

// Pipeline stage 1: Input sampling and sum precomputation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_p1 <= 64'b0;
        addb_p1 <= 64'b0;
        en_p1 <= 1'b0;
        for (int j = 0; j < NUM_SEGS; j = j + 1) begin
            sum0[j] <= {(SEG_WIDTH+1){1'b0}};
            sum1[j] <= {(SEG_WIDTH+1){1'b0}};
        end
    end else begin
        adda_p1 <= adda;
        addb_p1 <= addb;
        en_p1 <= i_en;
    end
end

// Pipeline stage 2: Carry propagation and sum selection
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int j = 0; j < NUM_SEGS; j = j + 1) begin
            selected_sum[j] <= {SEG_WIDTH{1'b0}};
            carry[j] <= 1'b0;
        end
        carry[NUM_SEGS] <= 1'b0;
        en_p2 <= 1'b0;
    end else begin
        carry[0] <= 1'b0;  // No carry in for first segment
        
        for (int j = 0; j < NUM_SEGS; j = j + 1) begin
            // Select correct sum based on carry from previous segment
            if (carry[j]) begin
                selected_sum[j] <= sum1[j][SEG_WIDTH-1:0];
                carry[j+1] <= sum1[j][SEG_WIDTH];
            end else begin
                selected_sum[j] <= sum0[j][SEG_WIDTH-1:0];
                carry[j+1] <= sum0[j][SEG_WIDTH];
            end
        end
        
        en_p2 <= en_p1;
    end
end

// Pipeline stage 3: Result assembly and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_p3 <= 65'b0;
        en_p3 <= 1'b0;
    end else begin
        // Combine all selected sums and final carry
        result_p3 <= {carry[NUM_SEGS], 
                     selected_sum[7], selected_sum[6], selected_sum[5], selected_sum[4],
                     selected_sum[3], selected_sum[2], selected_sum[1], selected_sum[0]};
        en_p3 <= en_p2;
    end
end

// Output assignment
always @(*) begin
    result = result_p3;
    o_en = en_p3;
end

endmodule