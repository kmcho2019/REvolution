module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output reg [31:0]  predict_history
);

    wire update_en = train_mispredicted || predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_en) begin
            if (train_mispredicted)
                predict_history <= {train_history[30:0], train_taken};
            else // predict_valid must be true here
                predict_history <= {predict_history[30:0], predict_taken};
        end
    end

endmodule