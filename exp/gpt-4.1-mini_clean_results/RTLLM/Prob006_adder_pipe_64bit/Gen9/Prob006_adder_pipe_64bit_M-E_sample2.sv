module adder_pipe_64bit(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Internal pipeline registers for inputs and carries
    reg [15:0] stageA [0:4]; // 4 stages + input register stage 0
    reg [15:0] stageB [0:4];
    reg        carry_in [0:4]; // carry-in per stage (stage 0 carry-in always 0)
    reg [15:0] sum_stage [1:4]; // sums computed by each stage

    // Enable pipeline to track valid data through pipeline
    reg [4:0] en_pipe;

    integer i;

    // 16-bit ripple carry adder combinational module instantiation using function
    // Returns sum and carry_out given 16-bit inputs and carry_in
    function [16:0] ripple_carry_16;
        input [15:0] a;
        input [15:0] b;
        input        cin;
        integer j;
        reg [16:0] c; // carry chain plus carry out
        reg [15:0] s;
        begin
            c[0] = cin;
            for (j=0; j<16; j=j+1) begin
                s[j] = a[j] ^ b[j] ^ c[j];
                c[j+1] = (a[j] & b[j]) | (a[j] & c[j]) | (b[j] & c[j]);
            end
            ripple_carry_16 = {c[16], s};
        end
    endfunction

    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i <= 4; i = i + 1) begin
                stageA[i] <= 16'd0;
                stageB[i] <= 16'd0;
                carry_in[i] <= 1'b0;
            end
            for (i = 1; i <= 4; i = i + 1) begin
                sum_stage[i] <= 16'd0;
            end
            en_pipe <= 5'b0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers load on i_en
            if (i_en) begin
                stageA[0] <= adda[15:0];
                stageB[0] <= addb[15:0];
                carry_in[0] <= 1'b0; // initial carry in zero
            end else begin
                // Hold previous inputs if not enabled
                stageA[0] <= stageA[0];
                stageB[0] <= stageB[0];
                carry_in[0] <= carry_in[0];
            end

            // Pipeline stage inputs and carries shift forward
            for (i = 1; i <= 4; i = i + 1) begin
                stageA[i] <= (i == 1) ? adda[i*16 +: 16] : stageA[i-1];
                stageB[i] <= (i == 1) ? addb[i*16 +: 16] : stageB[i-1];
                carry_in[i] <= (i == 1) ? carry_in[0] : carry_in[i-1];
            end

            // Stage 1 adder: bits [15:0]
            {carry_in[1], sum_stage[1]} <= ripple_carry_16(stageA[0], stageB[0], carry_in[0]);

            // Stage 2 adder: bits [31:16]
            {carry_in[2], sum_stage[2]} <= ripple_carry_16(stageA[1], stageB[1], carry_in[1]);

            // Stage 3 adder: bits [47:32]
            {carry_in[3], sum_stage[3]} <= ripple_carry_16(stageA[2], stageB[2], carry_in[2]);

            // Stage 4 adder: bits [63:48]
            {carry_in[4], sum_stage[4]} <= ripple_carry_16(stageA[3], stageB[3], carry_in[3]);

            // Advance input enable pipeline
            en_pipe <= {en_pipe[3:0], i_en};

            // Output the final result when pipeline data is valid (after stage 4)
            if (en_pipe[4]) begin
                // Assemble the result: bits 0..63 from sum_stage[1..4] concatenated, plus carry_out
                // sum_stage[1] = bits[15:0], sum_stage[2] = bits[31:16], sum_stage[3] = bits[47:32], sum_stage[4] = bits[63:48]
                result <= {carry_in[4], sum_stage[4], sum_stage[3], sum_stage[2], sum_stage[1]};
            end else begin
                result <= result;
            end

            o_en <= en_pipe[4];
        end
    end

endmodule