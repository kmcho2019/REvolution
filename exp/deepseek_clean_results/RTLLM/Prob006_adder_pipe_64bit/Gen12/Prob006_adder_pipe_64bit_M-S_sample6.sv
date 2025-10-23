module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output reg o_en
);

// Pipeline registers
reg carry;
reg [63:0] adda_pipe, addb_pipe;
reg [1:0] en_pipe;

// Stage 1: Add lower 32 bits
wire [32:0] sum_lower = adda[31:0] + addb[31:0];

// Stage 2: Add upper 32 bits with carry
wire [32:0] sum_upper = adda_pipe[63:32] + addb_pipe[63:32] + carry;

// Final result combination
assign result = {sum_upper, sum_lower[31:0]};

// Pipeline control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry <= 1'b0;
        adda_pipe <= 64'b0;
        addb_pipe <= 64'b0;
        en_pipe <= 2'b0;
        o_en <= 1'b0;
    end else begin
        carry <= sum_lower[32];
        adda_pipe <= adda;
        addb_pipe <= addb;
        en_pipe <= {en_pipe[0], i_en};
        o_en <= en_pipe[1];
    end
end

endmodule