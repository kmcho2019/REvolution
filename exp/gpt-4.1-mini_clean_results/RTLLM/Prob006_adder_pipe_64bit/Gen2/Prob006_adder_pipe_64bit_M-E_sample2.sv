module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output reg [64:0] result,
    output reg      o_en
);

    // Pipeline registers for sum bits (64 bits), carry (1 bit), and enable (1 bit)
    reg sum_pipe    [0:63];      // sum bit at each stage
    reg carry_pipe  [0:63];      // carry out from each stage
    reg en_pipe     [0:63];      // enable flag for valid data at each stage

    // Registers for input bits at each stage to add
    reg bit_a_pipe  [0:63];
    reg bit_b_pipe  [0:63];

    integer i;

    // Stage 0: load inputs bits and initial carry=0 when i_en asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_pipe[0]   <= 1'b0;
            carry_pipe[0] <= 1'b0;
            en_pipe[0]    <= 1'b0;
            bit_a_pipe[0] <= 1'b0;
            bit_b_pipe[0] <= 1'b0;
        end else begin
            if (i_en) begin
                bit_a_pipe[0] <= adda[0];
                bit_b_pipe[0] <= addb[0];
                en_pipe[0]    <= 1'b1;
            end else begin
                en_pipe[0]    <= 1'b0;
                bit_a_pipe[0] <= 1'b0;
                bit_b_pipe[0] <= 1'b0;
            end
            // Sum and carry computation for stage 0
            {carry_pipe[0], sum_pipe[0]} <= bit_a_pipe[0] + bit_b_pipe[0] + 1'b0; // carry-in = 0
        end
    end

    // Pipeline stages 1 to 63
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 1; i < 64; i = i + 1) begin
                sum_pipe[i]   <= 1'b0;
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
                bit_a_pipe[i] <= 1'b0;
                bit_b_pipe[i] <= 1'b0;
            end
        end else begin
            for (i = 1; i < 64; i = i + 1) begin
                // Shift input bits and enable from previous stage
                bit_a_pipe[i] <= adda[i];
                bit_b_pipe[i] <= addb[i];
                en_pipe[i]    <= en_pipe[i-1];

                // When valid enable, compute sum and carry
                if (en_pipe[i-1]) begin
                    {carry_pipe[i], sum_pipe[i]} <= bit_a_pipe[i] + bit_b_pipe[i] + carry_pipe[i-1];
                end else begin
                    sum_pipe[i]   <= 1'b0;
                    carry_pipe[i] <= 1'b0;
                end
            end
        end
    end

    // Assemble the full 65-bit result and output enable after last stage
    // Register the output to synchronize timing
    reg [63:0] sum_bits_reg;
    reg        carry_out_reg;
    reg        o_en_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_bits_reg <= 64'd0;
            carry_out_reg <= 1'b0;
            o_en_reg <= 1'b0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            if (en_pipe[63]) begin
                // Capture all sum bits from the pipeline stages
                // sum_pipe[i] are registered sum bits per stage i
                // Build sum vector by concatenation
                sum_bits_reg <= {
                    sum_pipe[63], sum_pipe[62], sum_pipe[61], sum_pipe[60],
                    sum_pipe[59], sum_pipe[58], sum_pipe[57], sum_pipe[56],
                    sum_pipe[55], sum_pipe[54], sum_pipe[53], sum_pipe[52],
                    sum_pipe[51], sum_pipe[50], sum_pipe[49], sum_pipe[48],
                    sum_pipe[47], sum_pipe[46], sum_pipe[45], sum_pipe[44],
                    sum_pipe[43], sum_pipe[42], sum_pipe[41], sum_pipe[40],
                    sum_pipe[39], sum_pipe[38], sum_pipe[37], sum_pipe[36],
                    sum_pipe[35], sum_pipe[34], sum_pipe[33], sum_pipe[32],
                    sum_pipe[31], sum_pipe[30], sum_pipe[29], sum_pipe[28],
                    sum_pipe[27], sum_pipe[26], sum_pipe[25], sum_pipe[24],
                    sum_pipe[23], sum_pipe[22], sum_pipe[21], sum_pipe[20],
                    sum_pipe[19], sum_pipe[18], sum_pipe[17], sum_pipe[16],
                    sum_pipe[15], sum_pipe[14], sum_pipe[13], sum_pipe[12],
                    sum_pipe[11], sum_pipe[10], sum_pipe[9],  sum_pipe[8],
                    sum_pipe[7],  sum_pipe[6],  sum_pipe[5],  sum_pipe[4],
                    sum_pipe[3],  sum_pipe[2],  sum_pipe[1],  sum_pipe[0]
                };
                carry_out_reg <= carry_pipe[63];
                o_en_reg <= 1'b1;
            end else begin
                sum_bits_reg <= 64'd0;
                carry_out_reg <= 1'b0;
                o_en_reg <= 1'b0;
            end
            result <= {carry_out_reg, sum_bits_reg};
            o_en <= o_en_reg;
        end
    end

endmodule