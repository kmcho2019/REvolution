module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8
) (
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

reg [STG_WIDTH+1:0] stage_results [0:NUM_STAGES-1];
reg [NUM_STAGES:0] counter;
reg [DATA_WIDTH:0] result_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        o_en <= 1'b0;
        for (i = 0; i < NUM_STAGES; i++) begin
            stage_results[i] <= 0;
        end
    end else begin
        if (i_en) begin
            counter <= 1;
            for (i = 0; i < NUM_STAGES; i++) begin
                stage_results[i] <= adda[i*STG_WIDTH +: STG_WIDTH] + addb[i*STG_WIDTH +: STG_WIDTH] + (i == 0 ? 0 : stage_results[i-1][STG_WIDTH]);
            end
        end else if (counter < NUM_STAGES) begin
            counter <= counter + 1;
        end else begin
            o_en <= 1'b1;
        end
    end
end

always @(*) begin
    result_reg = 0;
    for (i = 0; i < NUM_STAGES; i++) begin
        result_reg[i*STG_WIDTH +: STG_WIDTH] = stage_results[i][STG_WIDTH-1:0];
    end
    result_reg[DATA_WIDTH] = stage_results[NUM_STAGES-1][STG_WIDTH];
end

assign result = result_reg;

endmodule