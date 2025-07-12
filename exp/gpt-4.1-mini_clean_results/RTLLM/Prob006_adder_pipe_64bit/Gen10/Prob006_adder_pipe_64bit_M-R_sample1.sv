module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    // Pipeline depth: 65 stages (64 bits + carry out)

    // Shift registers holding one bit of operands per pipeline stage
    reg [63:0] adda_shift;       // Holds remaining bits of adda input
    reg [63:0] addb_shift;       // Holds remaining bits of addb input

    // Arrays to hold one bit of operand per pipeline stage
    reg stage_adda [0:63];
    reg stage_addb [0:63];

    // Carry pipeline: carry[0] is initial carry-in (0), carry[64] is final carry out
    reg carry [0:64];

    // Sum bits per stage
    reg sum_bit [0:63];

    // Enable shift register to track valid data through pipeline stages
    reg [64:0] en_pipe;

    integer i;

    // Load operands into shift registers when i_en asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_shift <= 64'b0;
            addb_shift <= 64'b0;
        end else if (i_en) begin
            adda_shift <= adda;
            addb_shift <= addb;
        end else begin
            // Shift left by one to prepare next bit for next stage
            // When pipeline is active, shift registers shift out bits from LSB to MSB
            // Only shift if previous stage consumed bit, so shift when i_en or pipeline ongoing
            // But to keep it simple: shift only when pipeline active
            if (|en_pipe[63:0]) begin
                adda_shift <= {1'b0, adda_shift[63:1]};
                addb_shift <= {1'b0, addb_shift[63:1]};
            end
        end
    end

    // Capture the next bit of operands into stage_adda[0] and stage_addb[0] when new data input
    // Shift the pipeline registers stage_adda and stage_addb down the pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<64; i=i+1) begin
                stage_adda[i] <= 1'b0;
                stage_addb[i] <= 1'b0;
            end
        end else begin
            // Shift operands in pipeline stages
            for (i=63; i>0; i=i-1) begin
                stage_adda[i] <= stage_adda[i-1];
                stage_addb[i] <= stage_addb[i-1];
            end
            // Load new bit at stage 0 from LSB of shift registers only when i_en is high or pipeline active
            if (i_en || |en_pipe[63:0]) begin
                stage_adda[0] <= adda_shift[0];
                stage_addb[0] <= addb_shift[0];
            end else begin
                stage_adda[0] <= 1'b0;
                stage_addb[0] <= 1'b0;
            end
        end
    end

    // Carry pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<=64; i=i+1)
                carry[i] <= 1'b0;
        end else begin
            // Initial carry-in is 0 when new operation starts
            if (i_en)
                carry[0] <= 1'b0;
            else
                carry[0] <= carry[0]; // hold

            // For stages 0 to 63, compute carry out and shift along pipeline
            for (i=0; i<64; i=i+1) begin
                if (i == 0) begin
                    // Only update carry[1] if pipeline stage 0 active (sum_bit will be computed next)
                    // But sum_bit depends on previous carry, so compute carry_out combinationally
                    carry[i+1] <= ((stage_adda[i] & stage_addb[i]) | (stage_adda[i] & carry[i]) | (stage_addb[i] & carry[i]));
                end else begin
                    carry[i+1] <= ((stage_adda[i] & stage_addb[i]) | (stage_adda[i] & carry[i]) | (stage_addb[i] & carry[i]));
                end
            end
        end
    end

    // Compute sum bits at each stage (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<64; i=i+1)
                sum_bit[i] <= 1'b0;
        end else begin
            for (i=0; i<64; i=i+1) begin
                sum_bit[i] <= stage_adda[i] ^ stage_addb[i] ^ carry[i];
            end
        end
    end

    // Enable pipeline shift register to track data validity
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipe <= 65'b0;
        else
            en_pipe <= {en_pipe[63:0], i_en};
    end

    // Assemble the final 65-bit result and update output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            o_en <= en_pipe[64];
            if (en_pipe[64]) begin
                reg [63:0] sum_vec;
                for (i=0; i<64; i=i+1)
                    sum_vec[i] = sum_bit[i];
                result <= {carry[64], sum_vec};
            end
        end
    end

endmodule