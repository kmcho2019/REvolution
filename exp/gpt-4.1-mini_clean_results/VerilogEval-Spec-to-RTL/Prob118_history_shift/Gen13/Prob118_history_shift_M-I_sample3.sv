module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;
    reg        update_en;

    // Compose the next history value depending on conditions:
    // Misprediction load has priority
    wire [31:0] mispred_load = {train_history[30:0], train_taken};
    wire [31:0] predict_shift = {history[30:0], predict_taken};

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            history <= mispred_load;
        end else if (predict_valid) begin
            history <= predict_shift;
        end
        // else hold current history, no toggling
    end

    assign predict_history = history;

endmodule