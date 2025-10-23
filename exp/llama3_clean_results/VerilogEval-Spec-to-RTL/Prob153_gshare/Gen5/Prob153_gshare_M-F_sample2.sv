// Top-level module
module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Instantiate predictor, history buffer, and PHT modules
Predictor predictor(
  .clk(clk),
  .areset(areset),
  .predict_valid(predict_valid),
  .predict_pc(predict_pc),
  .predict_taken(predict_taken),
  .predict_history(predict_history),
  .train_valid(train_valid),
  .train_taken(train_taken),
  .train_mispredicted(train_mispredicted),
  .train_history(train_history),
  .train_pc(train_pc)
);

endmodule

// History buffer module
module HistoryBuffer(
    input clk,
    input areset,
    input predict_taken,
    input predict_valid,
    output reg [6:0] history
);

reg [6:0] hist;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        hist <= 7'b0;
    end else if (predict_valid) begin
        if (predict_taken) begin
            hist <= {hist[5:0], 1'b1};
        end else begin
            hist <= {hist[5:0], 1'b0};
        end
    end
end

assign history = hist;

endmodule

// PHT module
module PHT(
    input clk,
    input areset,
    input [6:0] index,
    input [1:0] update,
    output reg [1:0] value
);

reg [1:0] table [127:0];

always @(posedge clk or posedge areset) begin
    if (areset) begin
        for (genvar i = 0; i < 128; i++) begin
            table[i] <= 2'b0;
        end
    end else if (update!= 2'b0) begin
        case (update)
            2'b01: table[index] <= (table[index] == 2'b11)? 2'b11 : table[index] + 1;
            2'b10: table[index] <= (table[index] == 2'b00)? 2'b00 : table[index] - 1;
        endcase
    end
end

assign value = table[index];

endmodule

// Predictor module
module Predictor(
    input clk,
    input areset,
    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,
    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

reg [6:0] history;
reg [1:0] pht_value;
reg [6:0] hist;

HistoryBuffer history_buffer(
  .clk(clk),
  .areset(areset),
  .predict_taken(predict_taken),
  .predict_valid(predict_valid),
  .history(hist)
);

PHT pht(
  .clk(clk),
  .areset(areset),
  .index(predict_pc ^ hist),
  .update(train_valid? (train_taken? 2'b01 : 2'b10) : 2'b00),
  .value(pht_value)
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
        history <= 7'b0;
    end else if (predict_valid) begin
        if (pht_value >= 2'b10) begin
            predict_taken <= 1'b1;
        end else begin
            predict_taken <= 1'b0;
        end
        predict_history <= hist;
    end else if (train_valid) begin
        if (train_mispredicted) begin
            history <= train_history;
        end
    end
end

endmodule