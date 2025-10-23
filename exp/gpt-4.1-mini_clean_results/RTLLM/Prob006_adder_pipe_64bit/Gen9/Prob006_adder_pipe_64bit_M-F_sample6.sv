module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16,
    parameter STAGES     = DATA_WIDTH / STG_WIDTH
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input       [DATA_WIDTH-1:0] adda,
    input       [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]  result,
    output reg                  o_en
);

    // Stage registers for operands, sums, enables, and carries
    reg [STG_WIDTH-1:0] add_a_s [0:STAGES-1];
    reg [STG_WIDTH-1:0] add_b_s [0:STAGES-1];

    reg [STG_WIDTH-1:0] sum_s   [0:STAGES-1];

    reg                 en_s    [0:STAGES-1];

    reg                 carry_in  [0:STAGES];
    reg                 carry_out [0:STAGES-1];

    integer i;

    // Initialize carry_in[0] to zero (no carry in for first stage)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_in[0] <= 1'b0;
        end else if (i_en) begin
            carry_in[0] <= 1'b0;
        end
    end

    // Pipeline stage 0: latch inputs and enable on i_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_a_s[0] <= {STG_WIDTH{1'b0}};
            add_b_s[0] <= {STG_WIDTH{1'b0}};
            en_s[0]    <= 1'b0;
        end else begin
            if (i_en) begin
                add_a_s[0] <= adda[STG_WIDTH-1:0];
                add_b_s[0] <= addb[STG_WIDTH-1:0];
                en_s[0]    <= 1'b1;
            end else begin
                en_s[0] <= 1'b0;
            end
        end
    end

    // Pipeline stages 1..STAGES-1: latch inputs and enable signals
    generate
        genvar idx;
        for (idx=1; idx < STAGES; idx=idx+1) begin : PIPE_STAGES
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    add_a_s[idx] <= {STG_WIDTH{1'b0}};
                    add_b_s[idx] <= {STG_WIDTH{1'b0}};
                    en_s[idx]    <= 1'b0;
                end else begin
                    add_a_s[idx] <= adda[(idx+1)*STG_WIDTH-1 -: STG_WIDTH];
                    add_b_s[idx] <= addb[(idx+1)*STG_WIDTH-1 -: STG_WIDTH];
                    en_s[idx]    <= en_s[idx-1];
                end
            end
        end
    endgenerate

    // Combinational addition per stage with registered carry_in, register sum and carry_out
    // We create a combinational block to calculate sum and carry_out for each stage based on registered inputs and carry_in.
    // Registers carry_in and carry_out are updated synchronously.

    // carry_in[0] is already registered before, we register carry_in[1..STAGES] next:
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<STAGES; i=i+1) begin
                carry_out[i] <= 1'b0;
                sum_s[i]     <= {STG_WIDTH{1'b0}};
            end
            for (i=1; i<=STAGES; i=i+1) begin
                carry_in[i]  <= 1'b0;
            end
        end else begin
            for (i=0; i<STAGES; i=i+1) begin
                // Add operands with carry_in
                {carry_out[i], sum_s[i]} <= add_a_s[i] + add_b_s[i] + carry_in[i];
            end
            // Update carry_in for next stage
            for (i=1; i<=STAGES; i=i+1) begin
                carry_in[i] <= carry_out[i-1];
            end
        end
    end

    // Output enable pipelined through all stages
    reg [STAGES-1:0] en_pipeline;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= {STAGES{1'b0}};
        end else begin
            en_pipeline <= {en_pipeline[STAGES-2:0], i_en};
        end
    end

    // Assemble final result and output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en   <= 1'b0;
        end else begin
            // Concatenate sums and the last carry out as MSB
            // sum_s[STAGES-1] is most significant slice, sum_s[0] least significant
            // Because sum_s is indexed from 0 to STAGES-1, we assemble in descending order:
            result <= {carry_out[STAGES-1], sum_s[STAGES-1]};
            for (i = STAGES-2; i >= 0; i = i - 1) begin
                result <= {result, sum_s[i]};
            end
            // The above loop concatenates incorrectly due to assignment in always block sequentially,
            // so better to build a temporary vector and assign once.

            // Use a temporary reg for assembling result:
        end
    end

    // Temporary reg to assemble result in a separate always block combinationally
    reg [DATA_WIDTH:0] result_assembled;

    always @(*) begin
        result_assembled = {carry_out[STAGES-1], sum_s[STAGES-1]};
        for (i = STAGES-2; i >= 0; i = i - 1) begin
            result_assembled = {result_assembled, sum_s[i]};
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en   <= 1'b0;
        end else begin
            result <= result_assembled;
            o_en   <= en_pipeline[STAGES-1];
        end
    end

endmodule