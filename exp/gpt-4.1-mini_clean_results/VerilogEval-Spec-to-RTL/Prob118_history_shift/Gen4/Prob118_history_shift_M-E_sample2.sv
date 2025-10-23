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

    wire update_enable;
    wire [31:0] next_history;

    // Clock enable: active only if misprediction or prediction valid
    assign update_enable = train_mispredicted | predict_valid;

    // Compute next history value with priority to misprediction
    // For rollback: shift train_history left by 1 bit, insert train_taken at LSB
    // For prediction update: shift current history left by 1 bit, insert predict_taken
    assign next_history = train_mispredicted ? 
                            {train_history[30:0], train_taken} : 
                            {predict_history[30:0], predict_taken};

    // Asynchronous reset block for clearing history
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
        // else hold current value (no write)
    end

endmodule