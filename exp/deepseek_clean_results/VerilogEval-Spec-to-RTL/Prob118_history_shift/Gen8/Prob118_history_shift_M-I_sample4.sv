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
    wire clk_enable = areset || predict_valid || train_mispredicted;
    wire gated_clk = clk & clk_enable;

    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (train_mispredicted) begin
            // Parallel prefix shift implementation (4 stages)
            history[7:0] <= {train_history[6:0], train_taken};
            history[15:8] <= {train_history[14:7], history[7]};
            history[23:16] <= {train_history[22:15], history[15]};
            history[31:24] <= {train_history[30:23], history[23]};
        end else if (predict_valid) begin
            // Parallel prefix shift implementation (4 stages)
            history[7:0] <= {history[6:0], predict_taken};
            history[15:8] <= {history[14:7], history[7]};
            history[23:16] <= {history[22:15], history[15]};
            history[31:24] <= {history[30:23], history[23]};
        end
    end

    assign predict_history = history;

endmodule