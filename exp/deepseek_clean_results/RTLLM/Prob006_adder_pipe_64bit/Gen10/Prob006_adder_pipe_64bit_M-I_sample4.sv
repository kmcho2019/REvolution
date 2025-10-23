module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH/STG_WIDTH;

// Pipeline registers
reg [STG_WIDTH-1:0] a [0:NUM_STAGES-1];
reg [STG_WIDTH-1:0] b [0:NUM_STAGES-1];
reg [0:NUM_STAGES-1] carry;
reg [NUM_STAGES:0] en_pipe;

// Intermediate sums
wire [STG_WIDTH:0] sum [0:NUM_STAGES-1];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < NUM_STAGES; i = i + 1) begin : stage
        if (i == 0) begin
            assign sum[i] = {1'b0, a[i]} + {1'b0, b[i]};
        end else begin
            assign sum[i] = {1'b0, a[i]} + {1'b0, b[i]} + {{(STG_WIDTH){1'b0}}, carry[i-1]};
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < NUM_STAGES; j = j + 1) begin
            a[j] <= {STG_WIDTH{1'b0}};
            b[j] <= {STG_WIDTH{1'b0}};
            carry[j] <= 1'b0;
        end
        en_pipe <= {(NUM_STAGES+1){1'b0}};
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Register first chunk
        a[0] <= adda[STG_WIDTH-1:0];
        b[0] <= addb[STG_WIDTH-1:0];
        carry[0] <= sum[0][STG_WIDTH];
        
        // Subsequent pipeline stages
        for (integer k = 1; k < NUM_STAGES; k = k + 1) begin
            a[k] <= adda[(k+1)*STG_WIDTH-1:k*STG_WIDTH];
            b[k] <= addb[(k+1)*STG_WIDTH-1:k*STG_WIDTH];
            carry[k] <= sum[k][STG_WIDTH];
        end
        
        // Compose final result
        for (integer m = 0; m < NUM_STAGES; m = m + 1) begin
            result[(m+1)*STG_WIDTH-1:m*STG_WIDTH] <= sum[m][STG_WIDTH-1:0];
        end
        result[DATA_WIDTH] <= sum[NUM_STAGES-1][STG_WIDTH];
        
        // Pipeline enable signal
        en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};
        o_en <= en_pipe[NUM_STAGES];
    end
end

endmodule