module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline width: 64 stages, one per bit
    // Registers per bit stage for inputs and carry
    reg [63:0] adda_pipe;
    reg [63:0] addb_pipe;
    reg [63:0] sum_pipe;
    reg        carry_pipe [0:64]; // carry_pipe[i]: carry-in for bit i; carry_pipe[0] = 0 at input
    reg [64:0] en_pipe; // enable pipeline shift register (64 bits + output)

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_pipe <= 64'd0;
            addb_pipe <= 64'd0;
            sum_pipe  <= 64'd0;
            for (i = 0; i <= 64; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            en_pipe <= 65'd0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[63:0], i_en};

            // Load inputs into stage 0 registers when i_en is high
            if (i_en) begin
                adda_pipe <= adda;
                addb_pipe <= addb;
            end else begin
                adda_pipe <= adda_pipe;
                addb_pipe <= addb_pipe;
            end

            // carry_pipe[0] is carry-in to bit 0, always 0 at new input
            if (i_en)
                carry_pipe[0] <= 1'b0;
            else
                carry_pipe[0] <= carry_pipe[0];

            // Process each bit stage: calculate sum bit and carry-out to next bit
            // sum_bit = adda_bit ^ addb_bit ^ carry_in
            // carry_out = majority of (adda_bit, addb_bit, carry_in)
            for (i = 0; i < 64; i = i + 1) begin
                // Use previous clock's inputs and carry_pipe[i] to compute sum and carry
                // Register results for next cycle
                // Here, since inputs are stable in adda_pipe and addb_pipe, and carry_pipe propagates,
                // compute sum and carry for next cycle registers
                // We do combinational add here for simplicity, but results registered on next clock
                // So implement as next stage registers

                // Temporary variables for calculation
                wire a_bit = adda_pipe[i];
                wire b_bit = addb_pipe[i];
                wire c_in  = carry_pipe[i];

                // Calculate sum and carry out
                wire sum_bit = a_bit ^ b_bit ^ c_in;
                wire carry_out = (a_bit & b_bit) | (b_bit & c_in) | (a_bit & c_in);

                // Register sum bit
                sum_pipe[i] <= sum_bit;

                // Register carry out for next bit stage
                carry_pipe[i+1] <= carry_out;
            end

            // After 64 cycles, output is valid: assemble result and output enable
            o_en <= en_pipe[64];

            if (en_pipe[64]) begin
                // Concatenate carry_out of MSB (bit 63) and sum bits [63:0]
                result <= {carry_pipe[64], sum_pipe};
            end else begin
                result <= result;
            end
        end
    end

endmodule