module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] history_reg;
    wire [31:0] next_history;
    wire update_enable;
    wire [31:0] shifted_prediction;
    wire [31:0] shifted_training;

    // Clock gating control
    assign update_enable = areset | predict_valid | train_mispredicted;

    // Shared shift logic (broken into chunks)
    assign shifted_prediction = {history_reg[30:24], history_reg[23:16], 
                               history_reg[15:8], history_reg[7:0], predict_taken};
    assign shifted_training = {train_history[30:24], train_history[23:16],
                             train_history[15:8], train_history[7:0], train_taken};

    // Priority-encoded next state logic
    always @(*) begin
        casex ({areset, train_mispredicted, predict_valid})
            3'b1??: next_history = 32'b0;  // Reset highest priority
            3'b01?: next_history = shifted_training;
            3'b001: next_history = shifted_prediction;
            default: next_history = history_reg;
        endcase
    end

    // Clock-gated register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (update_enable) begin
            history_reg <= next_history;
        end
    end

    // Registered output for better timing
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= history_reg;
        end
    end

endmodule