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

    reg [30:0] base_history;   // older 31 bits: history excluding youngest branch
    reg        youngest_bit;   // youngest branch bit (predict_history[0])

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            base_history <= 31'b0;
            youngest_bit <= 1'b0;
        end else if (train_mispredicted) begin
            // Rollback: load train_history[31:1] as base_history and train_history[0] as youngest_bit,
            // then overwrite youngest_bit with actual train_taken
            base_history <= train_history[31:1];
            youngest_bit <= train_taken;
        end else if (predict_valid) begin
            // Shift base_history left by one, push out oldest bit (discarded),
            // shift in previous youngest_bit as second youngest,
            // update youngest_bit with predict_taken
            base_history <= {base_history[29:0], youngest_bit};
            youngest_bit <= predict_taken;
        end
        // else no change, hold current state
    end

    // Concatenate youngest bit as LSB with base_history shifted accordingly
    // predict_history[0] is youngest_bit, predict_history[31:1] = base_history
    assign predict_history = {base_history, youngest_bit};

endmodule