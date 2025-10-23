module TopModule (
    input              clk,
    input              load,
    input      [511:0] data,
    output reg [511:0] q
);
    // Parameters
    localparam STAGES = 64;   // Number of pipeline stages
    localparam CHUNKSIZE = 8; // Cells per stage

    // Pipeline registers holding 8 bits each
    reg [CHUNKSIZE-1:0] stage_regs [0:STAGES-1];

    // Temporary wires for next state computation of each stage
    wire [CHUNKSIZE-1:0] next_stage [0:STAGES-1];

    // Helper function: compute next state of one cell for Rule 110
    function automatic bit rule110_cell(
        input bit left,
        input bit center,
        input bit right
    );
        rule110_cell = (~left & center) | (center ^ right);
    endfunction

    integer i, j;

    // Compute next state for each stage (8 cells)
    // We need to handle boundaries carefully:
    // - For cell 0 in stage s: left neighbor is bit 7 of stage s+1 (or 0 if s+1==STAGES)
    // - For cell 7 in stage s: right neighbor is bit 0 of stage s-1 (or 0 if s-1 < 0)
    // - Within the stage, neighbors are just adjacent bits

    // To simplify boundary conditions, define a helper to get neighbors safely
    function bit get_bit(
        input integer stage_idx,
        input integer cell_idx
    );
        if (stage_idx < 0 || stage_idx >= STAGES)
            get_bit = 1'b0; // boundary zero
        else
            get_bit = stage_regs[stage_idx][cell_idx];
    endfunction

    generate
        // Generate combinational logic for next_stage each clock cycle
        // Combinational block inside generate requires genvar, so workaround with a procedural block below
    endgenerate

    always @(*) begin
        // Compute next states for all stages and cells
        for (i = 0; i < STAGES; i = i + 1) begin
            for (j = 0; j < CHUNKSIZE; j = j + 1) begin
                bit left, center, right;
                center = stage_regs[i][j];
                // Left neighbor: cell to the left is cell j+1 in same stage if j<7 else cell 0 of next stage
                if (j < CHUNKSIZE-1) begin
                    left = stage_regs[i][j+1];
                end else begin
                    // left neighbor is cell 0 in next stage i+1, or 0 if none
                    left = get_bit(i+1, 0);
                end
                // Right neighbor: cell j-1 in same stage if j>0 else cell 7 in previous stage
                if (j > 0) begin
                    right = stage_regs[i][j-1];
                end else begin
                    // right neighbor is cell 7 in previous stage i-1, or 0 if none
                    right = get_bit(i-1, CHUNKSIZE-1);
                end
                next_stage[i][j] = rule110_cell(left, center, right);
            end
        end
    end

    // At clock edge, either load entire 512-bit input and split into 8-bit chunks into pipeline stages,
    // or update pipeline stages with their next states
    always @(posedge clk) begin
        if (load) begin
            // Load: break data into 64 chunks of 8 bits each, stage 0 gets data[7:0], stage 63 gets data[511:504]
            for (i = 0; i < STAGES; i = i + 1) begin
                stage_regs[i] <= data[i*CHUNKSIZE +: CHUNKSIZE];
            end
        end else begin
            // Advance each stage with its next state computed combinationally
            for (i = 0; i < STAGES; i = i + 1) begin
                stage_regs[i] <= next_stage[i];
            end
        end
    end

    // Output q is concatenation of all pipeline stages
    always @(*) begin
        for (i = 0; i < STAGES; i = i + 1) begin
            q[i*CHUNKSIZE +: CHUNKSIZE] = stage_regs[i];
        end
    end

endmodule