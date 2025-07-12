module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters
    localparam STAGES = 8;
    localparam STAGE_BITS = 8; // bits per stage

    // Pipeline registers for operands split into 8-bit chunks
    reg [STAGE_BITS-1:0] adda_pipe [0:STAGES-1];
    reg [STAGE_BITS-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for sums at each stage
    reg [STAGE_BITS-1:0] sum_pipe [0:STAGES-1];

    // Pipeline registers for carry signals between stages
    reg carry_pipe [0:STAGES]; 
    // carry_pipe[0] is carry-in to first stage (0)
    // carry_pipe[STAGES] is carry-out from last stage

    // Pipeline registers for output enable signal synchronized through pipeline
    reg en_pipe [0:STAGES];

    integer i;

    // Split input operands into 8-bit segments and register inputs on i_en
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(i=0; i<STAGES; i=i+1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
            end
            carry_pipe[0] <= 1'b0;
            for(i=1; i<=STAGES; i=i+1)
                carry_pipe[i] <= 1'b0;
            for(i=0; i<=STAGES; i=i+1)
                en_pipe[i] <= 1'b0;
        end else begin
            if(i_en) begin
                // Load inputs into pipeline operand registers
                for(i=0; i<STAGES; i=i+1) begin
                    adda_pipe[i] <= adda[i*STAGE_BITS +: STAGE_BITS];
                    addb_pipe[i] <= addb[i*STAGE_BITS +: STAGE_BITS];
                end
                carry_pipe[0] <= 1'b0; // No initial carry-in for ripple carry adder
            end else begin
                // Hold values if not enabled
                for(i=0; i<STAGES; i=i+1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                carry_pipe[0] <= carry_pipe[0];
            end
            // Propagate enable signal through pipeline stages
            en_pipe[0] <= i_en;
            for(i=1; i<=STAGES; i=i+1)
                en_pipe[i] <= en_pipe[i-1];
        end
    end

    // Each pipeline stage performs addition of 8 bits plus carry-in, storing sum and carry-out
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(i=0; i<STAGES; i=i+1) begin
                sum_pipe[i] <= 0;
            end
            for(i=1; i<=STAGES; i=i+1)
                carry_pipe[i] <= 1'b0;
        end else begin
            for(i=0; i<STAGES; i=i+1) begin
                // Use registered operands and carry_pipe[i] as carry-in
                // Sum calculation with carry propagation
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end
        end
    end

    // Register final result and output enable
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            result <= 0;
            o_en   <= 0;
        end else begin
            // Concatenate all sums and the final carry-out for result
            // result = {carry_out, sum7, sum6, ..., sum0}
            result <= {carry_pipe[STAGES], 
                       sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4], 
                       sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8]};
            // But sum_pipe indices are 0 to 7, so sum_pipe[7],...,sum_pipe[0]
            // Rewrite to correct order:
            // result[64] = carry_pipe[8]
            // result[63:56] = sum_pipe[7]
            // result[55:48] = sum_pipe[6]
            // ...
            // result[7:0] = sum_pipe[0]
            // We'll do a loop or direct concatenation:
            // Because Verilog does not support looping in concatenation, do manually:

            result <= {carry_pipe[STAGES], sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4], 
                                        sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};

            // Output enable updated from the last pipeline stage enable
            o_en <= en_pipe[STAGES];
        end
    end

endmodule