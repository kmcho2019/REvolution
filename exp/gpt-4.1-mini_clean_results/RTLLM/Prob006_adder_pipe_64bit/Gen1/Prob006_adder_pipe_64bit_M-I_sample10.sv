module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg                o_en
);
    // Calculate number of stages; assume DATA_WIDTH divisible by STG_WIDTH
    localparam integer STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for input operand segments and enable
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg                 en_pipe   [0:STAGES-1];

    // Carry registers between stages
    reg carry [0:STAGES]; // carry[0] initial carry-in

    // Sum pipeline registers per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Input pipeline: register operand segments and enable signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                en_pipe[i]   <= 1'b0;
            end
            carry[0] <= 1'b0;
        end else begin
            // Stage 0 input segment and enable
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            en_pipe[0]   <= i_en;
            carry[0]     <= 1'b0; // initial carry-in zero

            // Pipeline the rest of the input segments and enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
                addb_pipe[i] <= addb[(i+1)*STG_WIDTH-1 -: STG_WIDTH];
                en_pipe[i]   <= en_pipe[i-1];
            end
        end
    end

    // Addition and carry propagation pipelined per stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry[i] <= 1'b0;
            end
        end else begin
            for (i = 0; i < STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    {carry[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry[i];
                end else begin
                    sum_pipe[i] <= {STG_WIDTH{1'b0}};
                    carry[i+1]  <= 1'b0;
                end
            end
        end
    end

    // Output pipeline register for sum and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            o_en <= en_pipe[STAGES-1];
            if (en_pipe[STAGES-1]) begin
                // Concatenate sums from MSB segment down to LSB segment
                // sum_pipe[0] is LSB, sum_pipe[STAGES-1] is MSB segment
                result <= {carry[STAGES], 
                           sum_pipe[STAGES-1:0]};
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
            end
        end
    end

endmodule