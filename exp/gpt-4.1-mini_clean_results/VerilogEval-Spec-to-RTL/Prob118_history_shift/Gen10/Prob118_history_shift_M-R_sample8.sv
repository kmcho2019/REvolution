module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire [31:0] rollback_value;
    wire [31:0] shifted_value;
    wire [31:0] next_predict_history;

    // Compute rollback and shifted values
    assign rollback_value = {train_history[30:0], train_taken};
    assign shifted_value  = {predict_history[30:0], predict_taken};

    // Priority mux for next state:
    // Misprediction rollback has priority over prediction update
    assign next_predict_history = train_mispredicted ? rollback_value :
                                  (predict_valid ? shifted_value :
                                                   predict_history);

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else
            predict_history <= next_predict_history;
    end

endmodule