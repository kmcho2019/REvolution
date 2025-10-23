module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    wire gated_clk;
    wire prediction_update = predict_valid & ~train_mispredicted;
    wire misprediction_update = train_mispredicted;

    // Clock gating logic
    assign gated_clk = clk & (areset | prediction_update | misprediction_update);

    // Pre-compute both possible next states
    wire [31:0] next_prediction_state = {history_reg[30:0], predict_taken};
    wire [31:0] next_misprediction_state = {train_history[30:0], train_taken};

    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            case ({misprediction_update, prediction_update})
                2'b10: history_reg <= next_misprediction_state;
                2'b01: history_reg <= next_prediction_state;
                default: history_reg <= history_reg;
            endcase
        end
    end

    assign predict_history = history_reg;

endmodule