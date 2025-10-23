module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input  [31:0]   train_history,
    output reg [31:0] predict_history
);

    // Update enable signal - register updates only when necessary
    wire update_enable = train_mispredicted | predict_valid;

    // Compute next history value with priority: misprediction rollback > prediction update > hold
    wire [31:0] next_history;
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid     ? {predict_history[30:0], predict_taken} :
                                              predict_history;

    // Sequential logic with async reset, clock enable update_enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (update_enable) begin
            predict_history <= next_history;
        end
        // Else hold current state, reducing toggling
    end

endmodule