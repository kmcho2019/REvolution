module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 16;
localparam STAGES = DATA_WIDTH/STG_WIDTH;

// Pipeline registers
reg [STG_WIDTH-1:0] a_pipe [0:STAGES-1];
reg [STG_WIDTH-1:0] b_pipe [0:STAGES-1];
reg [STG_WIDTH*STAGES-1:0] sum_pipe;
reg [STAGES:0] en_pipe = 0;

// Carry chain
wire [STAGES:0] carry;
assign carry[0] = 0;

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : stage
        // Current stage operands
        wire [STG_WIDTH-1:0] a_curr = (i == 0) ? adda[STG_WIDTH*i +: STG_WIDTH] : a_pipe[i-1];
        wire [STG_WIDTH-1:0] b_curr = (i == 0) ? addb[STG_WIDTH*i +: STG_WIDTH] : b_pipe[i-1];
        
        // Stage sum with carry
        wire [STG_WIDTH:0] stg_sum = a_curr + b_curr + carry[i];
        
        // Carry propagation
        assign carry[i+1] = stg_sum[STG_WIDTH];
        
        // Register updates
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_pipe[i] <= 0;
                b_pipe[i] <= 0;
                sum_pipe[STG_WIDTH*i +: STG_WIDTH] <= 0;
            end else begin
                a_pipe[i] <= a_curr;
                b_pipe[i] <= b_curr;
                sum_pipe[STG_WIDTH*i +: STG_WIDTH] <= stg_sum[STG_WIDTH-1:0];
            end
        end
    end
endgenerate

// Enable pipeline (shift register)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= 0;
    end else begin
        en_pipe <= {en_pipe[STAGES-1:0], i_en};
    end
end

// Final result composition
assign result = {carry[STAGES], sum_pipe};
assign o_en = en_pipe[STAGES];

endmodule