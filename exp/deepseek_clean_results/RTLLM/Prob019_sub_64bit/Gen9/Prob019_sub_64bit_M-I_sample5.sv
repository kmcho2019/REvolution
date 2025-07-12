module sub_64bit (
    input clk,
    input enable,
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Registered inputs
    logic signed [63:0] A_reg, B_reg;
    logic signed [63:0] result_reg;
    logic overflow_reg;

    // Local parameters
    localparam OVERFLOW = 1'b1;
    localparam NO_OVERFLOW = 1'b0;
    localparam CHUNK_SIZE = 16;
    localparam NUM_CHUNKS = 64/CHUNK_SIZE;

    // Carry signals for hierarchical adder
    logic [NUM_CHUNKS:0] carry;
    logic signed [63:0] B_comp; // Two's complement of B

    // Clock gating
    logic gated_clk;
    assign gated_clk = clk & enable;

    always_ff @(posedge gated_clk) begin
        A_reg <= A;
        B_reg <= B;
        result <= result_reg;
        overflow <= overflow_reg;
    end

    // Two's complement of B (for A - B)
    assign B_comp = ~B_reg + 1'b1;

    // Hierarchical carry-select adder
    genvar i;
    generate
        for (i = 0; i < NUM_CHUNKS; i = i + 1) begin : adder_chunks
            localparam high = (i+1)*CHUNK_SIZE-1;
            localparam low = i*CHUNK_SIZE;
            
            if (i == 0) begin
                // First chunk with carry-in = 1 (for two's complement)
                assign {carry[1], result_reg[low+:CHUNK_SIZE]} = 
                    A_reg[low+:CHUNK_SIZE] + B_comp[low+:CHUNK_SIZE] + 1'b1;
            end else begin
                // Subsequent chunks with carry propagation
                assign {carry[i+1], result_reg[low+:CHUNK_SIZE]} = 
                    A_reg[low+:CHUNK_SIZE] + B_comp[low+:CHUNK_SIZE] + carry[i];
            end
        end
    endgenerate

    // Optimized overflow detection
    always_comb begin
        overflow_reg = (A_reg[63] != B_reg[63]) && (A_reg[63] != result_reg[63]) ? 
                      OVERFLOW : NO_OVERFLOW;
    end

endmodule