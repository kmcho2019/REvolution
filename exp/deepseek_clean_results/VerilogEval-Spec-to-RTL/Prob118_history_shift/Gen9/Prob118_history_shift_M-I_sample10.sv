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
    wire update_enable = predict_valid | train_mispredicted;
    wire clk_gated = clk & update_enable;

    assign predict_history = history;

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            // Parallel load for misprediction recovery
            history[31:1] <= train_history[30:0];
            history[0] <= train_taken;
        end else begin
            // Split shift into 4 segments for better timing
            history[31:24] <= {history[30:24], predict_taken};
            history[23:16] <= history[24:17];
            history[15:8] <= history[16:9];
            history[7:0] <= history[8:1];
        end
    end

endmodule