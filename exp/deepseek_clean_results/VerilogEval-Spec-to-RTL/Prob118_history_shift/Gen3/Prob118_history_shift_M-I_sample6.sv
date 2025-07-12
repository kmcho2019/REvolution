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
    wire [31:0] next_history;
    wire update_en;

    // Clock gating control
    assign update_en = areset | predict_valid | train_mispredicted;

    // Shared shift logic
    wire [31:0] shifted_pred = {history_reg[30:0], predict_taken};
    wire [31:0] shifted_train = {train_history[30:0], train_taken};

    // Priority-encoded next state logic
    always @(*) begin
        case (1'b1)
            train_mispredicted: next_history = shifted_train;
            predict_valid:      next_history = shifted_pred;
            default:            next_history = history_reg;
        endcase
    end

    // Register update with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (update_en) begin
            history_reg <= next_history;
        end
    end

    assign predict_history = history_reg;

endmodule