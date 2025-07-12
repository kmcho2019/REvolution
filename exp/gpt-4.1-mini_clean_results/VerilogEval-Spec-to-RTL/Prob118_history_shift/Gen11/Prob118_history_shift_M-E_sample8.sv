module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    wire [31:0] mispred_history = {train_history[30:0], train_taken};
    wire [31:0] predict_shifted = {predict_history[30:0], predict_taken};

    wire [31:0] next_history = train_mispredicted ? mispred_history :
                              predict_valid     ? predict_shifted :
                                                  predict_history;

    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else
            predict_history <= next_history;
    end

endmodule