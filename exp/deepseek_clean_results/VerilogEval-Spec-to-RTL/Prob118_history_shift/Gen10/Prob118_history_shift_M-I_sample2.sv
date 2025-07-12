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
    reg [31:0] next_history;
    reg update_en;

    // Clock gating control
    always @(*) begin
        update_en = areset || train_mispredicted || predict_valid;
    end

    // Next state computation (barrel shifter style)
    always @(*) begin
        if (areset) begin
            next_history = 32'b0;
        end else if (train_mispredicted) begin
            next_history = {train_history[30:0], train_taken};
        end else begin
            next_history = {history[30:0], predict_taken};
        end
    end

    // Registered stage with clock gating
    always @(posedge clk) begin
        if (update_en) begin
            history <= next_history;
        end
    end

    assign predict_history = history;

endmodule