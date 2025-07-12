module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16,
    parameter NUM_STAGES = DATA_WIDTH/STG_WIDTH
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Pipeline registers
reg [STG_WIDTH-1:0] a_pipe [NUM_STAGES-1:0];
reg [STG_WIDTH-1:0] b_pipe [NUM_STAGES-1:0];
reg [STG_WIDTH:0] sum_pipe [NUM_STAGES-1:0]; // Includes carry bit
reg [NUM_STAGES-1:0] en_pipe;

// Carry propagation register
reg [NUM_STAGES-2:0] carry_pipe;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < NUM_STAGES; i = i + 1) begin
            a_pipe[i] <= 0;
            b_pipe[i] <= 0;
            sum_pipe[i] <= 0;
            en_pipe[i] <= 0;
        end
        carry_pipe <= 0;
    end else begin
        // Stage 0: First segment
        a_pipe[0] <= adda[STG_WIDTH-1:0];
        b_pipe[0] <= addb[STG_WIDTH-1:0];
        sum_pipe[0] <= {1'b0, adda[STG_WIDTH-1:0]} + {1'b0, addb[STG_WIDTH-1:0]};
        en_pipe[0] <= i_en;
        
        // Intermediate stages
        for (integer i = 1; i < NUM_STAGES; i = i + 1) begin
            a_pipe[i] <= adda[(i+1)*STG_WIDTH-1:i*STG_WIDTH];
            b_pipe[i] <= addb[(i+1)*STG_WIDTH-1:i*STG_WIDTH];
            sum_pipe[i] <= {1'b0, a_pipe[i]} + {1'b0, b_pipe[i]} + carry_pipe[i-1];
            en_pipe[i] <= en_pipe[i-1];
            
            // Register carry for next stage
            if (i < NUM_STAGES-1) begin
                carry_pipe[i-1] <= sum_pipe[i][STG_WIDTH];
            end
        end
    end
end

// Output formation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        // Concatenate all partial sums
        result <= {sum_pipe[NUM_STAGES-1][STG_WIDTH:0], 
                  sum_pipe[NUM_STAGES-2][STG_WIDTH-1:0],
                  sum_pipe[NUM_STAGES-3][STG_WIDTH-1:0],
                  sum_pipe[0][STG_WIDTH-1:0]};
        o_en <= en_pipe[NUM_STAGES-1];
    end
end

endmodule