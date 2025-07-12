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
    
    // Next state calculation
    wire [31:0] next_history_pred = {history_reg[30:0], predict_taken};
    wire [31:0] next_history_mispred = {train_history[30:0], train_taken};
    wire [31:0] next_history = train_mispredicted ? next_history_mispred : 
                              (predict_valid ? next_history_pred : history_reg);

    // Register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            history_reg <= next_history;
        end
    end

    assign predict_history = history_reg;

endmodule