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
    
    // Next history calculation
    wire [31:0] next_history = 
        areset ? 32'b0 :               // Reset has highest priority
        train_mispredicted ? {train_history[30:0], train_taken} :  // Misprediction recovery
        predict_valid ? {history[30:0], predict_taken} :           // Normal prediction
        history;                                                    // No update

    // Sequential update
    always @(posedge clk or posedge areset) begin
        history <= next_history;
    end

    // Continuous output
    assign predict_history = history;

endmodule