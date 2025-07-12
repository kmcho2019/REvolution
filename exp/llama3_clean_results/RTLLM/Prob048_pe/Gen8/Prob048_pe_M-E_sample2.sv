module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Define the number of pipeline stages for multiplication
parameter NUM_STAGES = 4;

// Define the width of the operands and the accumulator
parameter DATA_WIDTH = 32;

// Register file to store intermediate results
reg [DATA_WIDTH-1:0] reg_file [NUM_STAGES-1:0];

// Control signals for the pipeline
reg [NUM_STAGES-1:0] valid;

// Initialize the register file and control signals
initial begin
    for (int i = 0; i < NUM_STAGES; i++) begin
        reg_file[i] <= 0;
        valid[i] <= 0;
    end
end

// Pipeline stage 1: Multiplication
always @(posedge clk) begin
    if (rst) begin
        reg_file[0] <= 0;
        valid[0] <= 0;
    end else begin
        reg_file[0] <= a * b;
        valid[0] <= 1;
    end
end

// Pipeline stages 2 to NUM_STAGES-1: Accumulation
generate
    for (genvar i = 1; i < NUM_STAGES; i++) begin
        always @(posedge clk) begin
            if (rst) begin
                reg_file[i] <= 0;
                valid[i] <= 0;
            end else if (valid[i-1]) begin
                reg_file[i] <= reg_file[i-1] + reg_file[i-2];
                valid[i] <= 1;
            end else begin
                reg_file[i] <= reg_file[i];
                valid[i] <= 0;
            end
        end
    end
endgenerate

// Final stage: Output
always @(posedge clk) begin
    if (rst) begin
        c <= 0;
    end else if (valid[NUM_STAGES-1]) begin
        c <= reg_file[NUM_STAGES-1];
    end else begin
        c <= c;
    end
end

endmodule