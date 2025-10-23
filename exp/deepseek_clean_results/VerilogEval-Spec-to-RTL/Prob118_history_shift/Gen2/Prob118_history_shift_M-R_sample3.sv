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

    reg [31:0] history;
    wire [31:0] next_history;

    // Reset has highest priority
    wire reset_history = areset ? 32'b0 : 
                       // Then misprediction
                       train_mispredicted ? {train_history[30:0], train_taken} :
                       // Then prediction
                       predict_valid ? {history[30:0], predict_taken} :
                       // Finally hold value
                       history;

    assign next_history = reset_history;

    always @(posedge clk) begin
        history <= next_history;
    end

    assign predict_history = history;

endmodule