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

// Register the inputs that affect history to reduce glitches
reg predict_taken_r;
reg train_taken_r;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_taken_r <= 1'b0;
        train_taken_r <= 1'b0;
    end else begin
        predict_taken_r <= predict_taken;
        train_taken_r <= train_taken;
    end
end

wire update_enable = train_mispredicted | predict_valid;

wire [31:0] shifted_history = {predict_history[30:0], predict_taken_r};
wire [31:0] mispredicted_history = {train_history[30:0], train_taken_r};

wire [31:0] next_history = train_mispredicted ? mispredicted_history :
                          predict_valid     ? shifted_history :
                                              predict_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'b0;
    end else if (update_enable) begin
        predict_history <= next_history;
    end
end

endmodule