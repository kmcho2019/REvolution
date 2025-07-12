module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [15:0] history_stage1;
reg [15:0] history_stage2;

always @(posedge clk or posedge areset) 
    if (areset) begin
        history_stage1 <= 0;
        history_stage2 <= 0;
    end 
    else if (train_mispredicted) begin
        history_stage1 <= train_history[15:0];
        history_stage2 <= train_history[31:16];
    end 
    else if (predict_valid) begin
        history_stage1 <= {history_stage1[14:0], predict_taken};
        history_stage2 <= {history_stage2[14:0], history_stage1[15]};
    end 
    else begin
        history_stage1 <= history_stage1;
        history_stage2 <= history_stage2;
    end

assign predict_history = {history_stage2, history_stage1};

endmodule