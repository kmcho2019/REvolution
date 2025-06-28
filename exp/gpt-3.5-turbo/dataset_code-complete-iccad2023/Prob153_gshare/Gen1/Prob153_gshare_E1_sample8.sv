module gshare_predictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output predict_taken,
  output [6:0] predict_history,

  input train_valid,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);

  // Parameters
  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;

  // State machine states
  parameter IDLE = 2'b00;
  parameter PREDICTION = 2'b01;
  parameter TRAINING = 2'b10;

  // Registers for PHT, global history, and state
  reg [1:0] pht[PHT_SIZE-1:0];
  reg [6:0] global_history;
  reg [1:0] state;

  // Intermediate signals
  reg [6:0] index;
  reg taken;
  reg [6:0] history;

  // State machine
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= IDLE;
      pht <= 0;
      global_history <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          if (predict_valid) begin
            index <= predict_pc ^ global_history;
            state <= PREDICTION;
          end
          else if (train_valid) begin
            index <= train_pc ^ global_history;
            history <= train_history;
            taken <= train_taken;
            state <= TRAINING;
          end
        end
        PREDICTION: begin
          predict_taken <= pht[index];
          predict_history <= global_history;
          state <= IDLE;
        end
        TRAINING: begin
          pht[index] <= (taken && pht[index] < 3) ? pht[index] + 1 :
                        (!taken && pht[index] > 0) ? pht[index] - 1 : pht[index];
          global_history <= history;
          state <= IDLE;
        end
        default: state <= IDLE;
      endcase
    end
  end

endmodule