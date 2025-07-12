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
    wire update_enable = predict_valid | train_mispredicted;
    wire clk_gated = clk & update_enable;

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Hierarchical concatenation for better timing
                history_reg[31:24] <= {train_history[22:16], train_taken};
                history_reg[23:16] <= train_history[15:8];
                history_reg[15:8] <= train_history[7:0];
                history_reg[7:0] <= {train_history[6:0], train_taken};
            end else if (predict_valid) begin
                // Parallel shift implementation
                history_reg[31:24] <= {history_reg[23], history_reg[22:16]};
                history_reg[23:16] <= {history_reg[15], history_reg[14:8]};
                history_reg[15:8] <= {history_reg[7], history_reg[6:0]};
                history_reg[7:0] <= {history_reg[6:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule