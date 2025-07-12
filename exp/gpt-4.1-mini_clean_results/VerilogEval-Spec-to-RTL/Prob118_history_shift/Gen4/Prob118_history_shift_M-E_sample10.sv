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

    reg update_enable;
    reg [31:0] next_history;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_history;
    end

    // Combinational logic for next state and enable signal
    always @* begin
        if (train_mispredicted) begin
            // Roll back history: shift train_history left by 1 bit and insert train_taken at LSB
            next_history = {train_history[30:0], train_taken};
            update_enable = 1'b1;
        end else if (predict_valid) begin
            // Shift in predict_taken at LSB
            next_history = {predict_history[30:0], predict_taken};
            update_enable = 1'b1;
        end else begin
            next_history = predict_history;
            update_enable = 1'b0;
        end
    end

endmodule