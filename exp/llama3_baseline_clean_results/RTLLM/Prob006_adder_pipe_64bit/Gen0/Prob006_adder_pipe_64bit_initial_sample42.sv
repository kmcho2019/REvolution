module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of pipeline stages
localparam STAGES = 64;

// Define the width of each pipeline stage
localparam WIDTH = 1;

// Define the width of the input operands
localparam INPUT_WIDTH = 64;

// Define the width of the output result
localparam OUTPUT_WIDTH = 65;

// Define the internal signals
reg [INPUT_WIDTH-1:0] stage_a [STAGES-1:0];
reg [INPUT_WIDTH-1:0] stage_b [STAGES-1:0];
reg [STAGES-1:0] stage_cin;
reg [STAGES-1:0] stage_cout;
reg [OUTPUT_WIDTH-1:0] stage_result [STAGES-1:0];
reg i_en_pipe;

// Pipeline stage registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < STAGES; i++) begin
            stage_a[i] <= 0;
            stage_b[i] <= 0;
            stage_cin[i] <= 0;
            stage_cout[i] <= 0;
        end
        i_en_pipe <= 0;
    end else if (i_en) begin
        stage_a[0] <= adda[0];
        stage_b[0] <= addb[0];
        i_en_pipe <= 1;
    end else if (i_en_pipe) begin
        for (int i = 0; i < STAGES-1; i++) begin
            stage_a[i+1] <= stage_a[i];
            stage_b[i+1] <= stage_b[i];
        end
        i_en_pipe <= (i_en_pipe && (stage_a[STAGES-1] != 0 || stage_b[STAGES-1] != 0)) ? 1 : 0;
    end
end

// Full adder logic
always @(*) begin
    for (int i = 0; i < STAGES; i++) begin
        if (i == 0) begin
            stage_cin[i] = 0;
        end else begin
            stage_cin[i] = stage_cout[i-1];
        end
        {stage_result[i][WIDTH-1], stage_cout[i]} = stage_a[i] + stage_b[i] + stage_cin[i];
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else if (i_en_pipe && stage_a[STAGES-1] == 0 && stage_b[STAGES-1] == 0) begin
        result <= {stage_cout[STAGES-1], stage_result[STAGES-1]};
        o_en <= 1;
    end else begin
        o_en <= 0;
    end
end

endmodule