module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Pipeline parameters
    localparam STAGES = 8;
    localparam WIDTH = 8; // bits per stage
    
    // Pipeline registers for inputs segments
    reg [WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg             en_pipe     [0:STAGES-1];
    
    // Carry registers between stages
    reg carry [0:STAGES];
    
    // Sum segments registers (to hold intermediate sums per stage)
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;
    
    // Pipeline input registers and enable synchronization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                en_pipe[i]   <= 0;
            end
            carry[0] <= 1'b0;
        end else begin
            // Stage 0 input registers get the input operands and enable
            adda_pipe[0] <= adda[WIDTH-1:0];
            addb_pipe[0] <= addb[WIDTH-1:0];
            en_pipe[0]   <= i_en;
            carry[0]     <= 1'b0; // initial carry-in zero
            
            // Shift the rest of the pipeline registers
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[(i+1)*WIDTH-1 -: WIDTH];
                addb_pipe[i] <= addb[(i+1)*WIDTH-1 -: WIDTH];
                en_pipe[i]   <= en_pipe[i-1];
            end
        end
    end

    // Stage-wise addition and carry propagation with pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
            end
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry[i] <= 0;
            end
        end else begin
            // Add each 8-bit segment + carry from previous stage
            for (i = 0; i < STAGES; i = i + 1) begin
                // Perform addition only if en_pipe[i] is set, else zero sums and carry
                if (en_pipe[i]) begin
                    {carry[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry[i];
                end else begin
                    sum_pipe[i] <= 0;
                    carry[i+1]  <= 0;
                end
            end
        end
    end
    
    // Register output result and output enable
    // Since sum_pipe and carry are registered at same clock,
    // we output the concatenation after last stage sum and carry
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 0;
        end else begin
            // o_en valid when last stage enable is set (pipeline full)
            o_en <= en_pipe[STAGES-1];
            if (en_pipe[STAGES-1]) begin
                // Concatenate all sum segments in correct order, plus final carry-out
                // sum_pipe are registered sums of each stage 8-bits
                // Index 0 = LSB, index 7 = MSB segment
                result <= {carry[STAGES], 
                           sum_pipe[STAGES-1], 
                           sum_pipe[STAGES-2], 
                           sum_pipe[STAGES-3], 
                           sum_pipe[STAGES-4], 
                           sum_pipe[STAGES-5], 
                           sum_pipe[STAGES-6], 
                           sum_pipe[STAGES-7], 
                           sum_pipe[0]};
            end else begin
                result <= 0;
            end
        end
    end

endmodule