module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] adda_pipe [0:7];
reg [63:0] addb_pipe [0:7];
reg [7:0] carry_pipe [0:8]; // carry[0] is initial carry-in (0)
reg [7:0] sum_pipe [0:7];
reg [7:0] en_pipe;

// Initialize pipeline registers
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            adda_pipe[i] <= 64'b0;
            addb_pipe[i] <= 64'b0;
            sum_pipe[i] <= 8'b0;
        end
        for (i = 0; i < 9; i = i + 1) begin
            carry_pipe[i] <= 1'b0;
        end
        en_pipe <= 8'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registers
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        carry_pipe[0] <= 1'b0; // Initial carry-in is 0
        en_pipe[0] <= i_en;

        // Pipeline stages 1-7
        for (i = 1; i < 8; i = i + 1) begin
            adda_pipe[i] <= adda_pipe[i-1];
            addb_pipe[i] <= addb_pipe[i-1];
            en_pipe[i] <= en_pipe[i-1];
        end

        // Carry and sum calculation for each stage
        for (i = 0; i < 8; i = i + 1) begin
            {carry_pipe[i+1], sum_pipe[i]} = adda_pipe[i][(i*8)+7:i*8] + 
                                             addb_pipe[i][(i*8)+7:i*8] + 
                                             carry_pipe[i];
        end

        // Final result assembly
        result <= {carry_pipe[8], 
                  sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                  sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};

        // Output enable is the last enable in pipeline
        o_en <= en_pipe[7];
    end
end

endmodule