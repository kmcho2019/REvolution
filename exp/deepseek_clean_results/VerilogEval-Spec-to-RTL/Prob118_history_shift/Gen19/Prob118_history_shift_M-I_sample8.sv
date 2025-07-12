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

    reg [31:0] current_history;
    wire update_enable = predict_valid | train_mispredicted;
    wire [31:0] next_history;

    // Clock gating logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_history <= 32'b0;
        end else if (update_enable) begin
            current_history <= next_history;
        end
    end

    // Optimized shift logic
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          {current_history[30:0], predict_taken};

    assign predict_history = current_history;

endmodule