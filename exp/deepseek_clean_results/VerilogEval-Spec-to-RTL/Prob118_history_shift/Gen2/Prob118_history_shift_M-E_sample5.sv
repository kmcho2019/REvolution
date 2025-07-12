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

    reg [31:0] current_history;
    reg [31:0] speculative_history;
    reg use_speculative;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
            speculative_history <= 32'b0;
            use_speculative <= 1'b0;
        end else begin
            if (train_mispredicted) begin
                // On misprediction, update current history and reset speculative
                current_history <= {train_history[30:0], train_taken};
                speculative_history <= {train_history[30:0], train_taken};
                use_speculative <= 1'b0;
            end else if (predict_valid) begin
                // Normal prediction - update speculative history
                speculative_history <= {speculative_history[30:0], predict_taken};
                use_speculative <= 1'b1;
            end
        end
    end

    assign predict_history = use_speculative ? speculative_history : current_history;

endmodule