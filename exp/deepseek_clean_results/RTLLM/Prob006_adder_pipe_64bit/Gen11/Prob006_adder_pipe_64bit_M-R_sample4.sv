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
reg carry1, carry2;
reg [2:0] en_pipe;

// Stage 1: Add bits 0-20
wire [21:0] sum1 = adda[20:0] + addb[20:0];

// Stage 2: Add bits 21-41 with carry from stage1
wire [21:0] sum2 = adda[41:21] + addb[41:21] + carry1;

// Stage 3: Add bits 42-63 with carry from stage2
wire [22:0] sum3 = adda[63:42] + addb[63:42] + carry2;

// Final result combination
assign result = {sum3[22], sum3[21:0], sum2[20:0], sum1[20:0]};

// Pipeline control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry1 <= 1'b0;
        carry2 <= 1'b0;
        en_pipe <= 3'b0;
        o_en <= 1'b0;
    end else begin
        carry1 <= sum1[21];
        carry2 <= sum2[21];
        en_pipe <= {en_pipe[1:0], i_en};
        o_en <= en_pipe[2];
    end
end

endmodule