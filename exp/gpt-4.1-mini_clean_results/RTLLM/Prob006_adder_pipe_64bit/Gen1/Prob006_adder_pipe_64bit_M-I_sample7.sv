module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result, // one bit wider for carry-out
    output reg                o_en
);

    // Derived parameters
    localparam STAGES = (DATA_WIDTH + STG_WIDTH - 1) / STG_WIDTH; // ceiling division

    // Pipeline registers: operand slices, enable signals
    reg [STG_WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg                 en_pipe     [0:STAGES-1];

    // Sum segments and carry registers between stages
    reg [STG_WIDTH-1:0] sum_pipe    [0:STAGES-1];
    reg                 carry       [0:STAGES]; // carry[0] is initial carry-in = 0

    integer i;

    // Input pipeline registers and enable shifting
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                en_pipe[i]   <= 0;
            end
            carry[0] <= 1'b0;
        end else begin
            // Load first stage slice and enable from input
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            en_pipe[0]   <= i_en;
            carry[0]     <= 1'b0; // initial carry-in zero

            // Pipeline rest of slices and enables
            for (i = 1; i < STAGES; i = i + 1) begin
                // For last slice, if DATA_WIDTH not multiple of STG_WIDTH, slice partial bits zero-extended
                if ((i+1)*STG_WIDTH <= DATA_WIDTH) begin
                    adda_pipe[i] <= adda[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
                    addb_pipe[i] <= addb[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
                end else begin
                    // partial slice size
                    integer rem;
                    rem = DATA_WIDTH - i*STG_WIDTH;
                    adda_pipe[i] <= { {(STG_WIDTH-rem){1'b0}}, adda[DATA_WIDTH-1 -: rem] };
                    addb_pipe[i] <= { {(STG_WIDTH-rem){1'b0}}, addb[DATA_WIDTH-1 -: rem] };
                end
                en_pipe[i] <= en_pipe[i-1];
            end
        end
    end

    // Stage-wise addition and carry propagation (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
            end
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry[i] <= 0;
            end
        end else begin
            for (i = 0; i < STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry[i];
                end else begin
                    sum_pipe[i] <= 0;
                    carry[i+1]  <= 0;
                end
            end
        end
    end

    // Assemble final result and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            o_en <= 1'b0;
        end else begin
            o_en <= en_pipe[STAGES-1];
            if (en_pipe[STAGES-1]) begin
                // Concatenate sum segments from MSB stage down to LSB stage correctly
                // Take care partial bits if any
                // result = {final_carry, sum[STAGES-1], ..., sum[0]}
                reg [DATA_WIDTH-1:0] concat_sum;
                integer j;
                integer bit_pos;
                concat_sum = 0;
                bit_pos = 0;
                for (j = 0; j < STAGES; j = j + 1) begin
                    if ((j+1)*STG_WIDTH <= DATA_WIDTH) begin
                        concat_sum[bit_pos +: STG_WIDTH] = sum_pipe[j];
                        bit_pos = bit_pos + STG_WIDTH;
                    end else begin
                        integer rembits;
                        rembits = DATA_WIDTH - j*STG_WIDTH;
                        concat_sum[bit_pos +: rembits] = sum_pipe[j][rembits-1:0];
                        bit_pos = bit_pos + rembits;
                    end
                end
                result <= {carry[STAGES], concat_sum};
            end else begin
                result <= 0;
            end
        end
    end

endmodule