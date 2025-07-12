module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history;
    wire       update_enable = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else if (update_enable) begin
            if (train_mispredicted)
                history <= {train_history[30:0], train_taken};
            else // predict_valid == 1
                history <= {history[30:0], predict_taken};
        end
    end

    assign predict_history = history;

endmodule