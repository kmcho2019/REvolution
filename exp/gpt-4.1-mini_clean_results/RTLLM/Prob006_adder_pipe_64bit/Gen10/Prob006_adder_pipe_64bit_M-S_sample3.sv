module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    reg [7:0] sum_stage [0:7];     // 8 pipeline sum registers, 8 bits each
    reg       carry_stage [0:8];   // carry registers, carry_stage[0] = 0 initially
    reg       en_stage [0:8];      // pipeline enable registers

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset all pipeline registers
            for (i = 0; i <= 7; i = i + 1) begin
                sum_stage[i] <= 8'b0;
                carry_stage[i] <= 1'b0;
                en_stage[i] <= 1'b0;
            end
            carry_stage[8] <= 1'b0;
            en_stage[8] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // stage 0 carry-in always zero
            carry_stage[0] <= 1'b0;
            en_stage[0] <= i_en;

            // stage 0 addition
            {carry_stage[1], sum_stage[0]} <= adda[7:0] + addb[7:0] + carry_stage[0];
            en_stage[1] <= en_stage[0];

            // pipeline stages 1 to 7
            for (i = 1; i < 8; i = i + 1) begin
                {carry_stage[i+1], sum_stage[i]} <= adda[8*i +: 8] + addb[8*i +: 8] + carry_stage[i];
                en_stage[i+1] <= en_stage[i];
            end

            // output register
            result <= {carry_stage[8],
                       sum_stage[7], sum_stage[6], sum_stage[5], sum_stage[4],
                       sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};
            o_en <= en_stage[8];
        end
    end

endmodule