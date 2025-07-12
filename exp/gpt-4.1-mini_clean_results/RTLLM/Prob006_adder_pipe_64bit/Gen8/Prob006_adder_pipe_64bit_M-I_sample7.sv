module adder_pipe_64bit #(
    parameter WIDTH    = 64,
    parameter STG_BITS = 4,
    parameter STG_NUM  = WIDTH / STG_BITS  // 16 stages for 64-bit with 4 bits per stage
)(
    input                  clk,
    input                  rst_n,
    input                  i_en,
    input      [WIDTH-1:0] adda,
    input      [WIDTH-1:0] addb,
    output reg [WIDTH:0]   result,
    output reg             o_en
);

    // ---- Pipeline registers ----
    // Operand slices per stage
    reg [STG_BITS-1:0] adda_pipe [0:STG_NUM-1];
    reg [STG_BITS-1:0] addb_pipe [0:STG_NUM-1];

    // Sum slices per stage
    reg [STG_BITS-1:0] sum_pipe [0:STG_NUM-1];

    // Carry between stages: carry_pipe[i] is carry-in to stage i
    reg carry_pipe [0:STG_NUM];  // STG_NUM+1 carries: carry_pipe[0] = 0 at input

    // Enable pipeline shift register to track valid data
    reg [STG_NUM-1:0] en_pipe;

    integer i;

    // Helper function: concatenate array of slices to form final result
    // Since Verilog can't directly do array-to-vector concat,
    // we'll implement this with a function inside always_comb block below.

    // Load operand slices at stage 0 on i_en, shift pipeline registers forward each cycle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < STG_NUM; i = i + 1) begin
                adda_pipe[i] <= {STG_BITS{1'b0}};
                addb_pipe[i] <= {STG_BITS{1'b0}};
                sum_pipe[i]  <= {STG_BITS{1'b0}};
            end
            for (i = 0; i <= STG_NUM; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            en_pipe <= {STG_NUM{1'b0}};
            result <= {(WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline, push current i_en at LSB
            en_pipe <= {en_pipe[STG_NUM-2:0], i_en};

            // Stage 0: capture slices from input operands when i_en=1
            if (i_en) begin
                for (i = 0; i < STG_NUM; i = i + 1) begin
                    // Slice operands: from MSB (63 downto 0)
                    adda_pipe[i] <= adda[(i+1)*STG_BITS-1 -: STG_BITS];
                    addb_pipe[i] <= addb[(i+1)*STG_BITS-1 -: STG_BITS];
                end
                carry_pipe[0] <= 1'b0;  // Initial carry-in for first stage is zero
            end else begin
                // If no input, keep operands and carry_pipe[0] stable
                // For synthesis friendliness, registers hold their values by default
                carry_pipe[0] <= carry_pipe[0];
                for (i = 0; i < STG_NUM; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
            end

            // Compute each stage: add operand slices + carry-in from previous stage
            // Register sum and carry-out for next stage
            for (i = 0; i < STG_NUM; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    // When invalid, keep previous sum and carry_pipe stable
                    sum_pipe[i] <= sum_pipe[i];
                    carry_pipe[i+1] <= carry_pipe[i+1];
                end
            end

            // Output assignment: when last stage valid enable asserted
            if (en_pipe[STG_NUM-1]) begin
                // Assemble final result from sum_pipe slices and final carry_pipe
                // MSB slices at low index 15, LSB slices at index 0
                // We'll build a temporary wire vector to assemble

                reg [WIDTH-1:0] sum_assembled;
                sum_assembled = {WIDTH{1'b0}};
                for (i = 0; i < STG_NUM; i = i + 1) begin
                    // Place each sum_pipe[i] at corresponding bits in sum_assembled
                    // Indexing from MSB to LSB: stage 15 is bits [63:60], stage 0 is [3:0]
                    sum_assembled[(STG_NUM-1 - i)*STG_BITS +: STG_BITS] = sum_pipe[i];
                end

                result <= {carry_pipe[STG_NUM], sum_assembled};
                o_en <= 1'b1;
            end else begin
                result <= {(WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule