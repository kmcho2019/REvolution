module TopModule(
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
reg clk_en;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 32'd0;
        clk_en <= 1'b0;
    end else if (train_mispredicted || predict_valid) begin
        // Update history register only when necessary
        if (train_mispredicted) begin
            history <= {train_history, train_taken};
        end else if (predict_valid) begin
            history <= {history[30:0], predict_taken};
        end
        clk_en <= 1'b1;
    end else begin
        // No update if neither predict_valid nor train_mispredicted
        history <= history;
        clk_en <= 1'b0;
    end
end

assign predict_history = history;

// Clock gating to reduce power consumption
assign clk_history = clk_en? clk : 1'b0;

endmodule