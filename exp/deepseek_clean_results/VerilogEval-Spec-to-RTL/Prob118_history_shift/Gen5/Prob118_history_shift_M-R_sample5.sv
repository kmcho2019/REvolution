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
    wire [31:0] misprediction_update;
    wire [31:0] prediction_update;

    // Calculate possible updates
    assign misprediction_update = {train_history[30:0], train_taken};
    assign prediction_update = {history_reg[30:0], predict_taken};

    // Next state logic with explicit priority
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            case (1'b1)
                train_mispredicted: history_reg <= misprediction_update;
                predict_valid:     history_reg <= prediction_update;
                default:           history_reg <= history_reg;
            endcase
        end
    end

    assign predict_history = history_reg;

endmodule