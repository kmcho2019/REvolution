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

// Clock enable: update only when prediction or misprediction occurs
wire update_enable = train_mispredicted | predict_valid;

// For prediction update: shift in predict_taken at LSB, drop oldest MSB
wire [31:0] predicted_shifted = {predict_history[30:0], predict_taken};

// For misprediction update:
// Roll back history by removing youngest bit (predict_history[0]) and append actual taken bit
// As per problem, train_history is before mispredicted branch, so
// we take train_history[31:1] as the older history bits and append train_taken at LSB
wire [31:0] corrected_history = {train_history[31:1], train_taken};

// Next state mux
wire [31:0] next_history = train_mispredicted ? corrected_history :
                          predict_valid     ? predicted_shifted :
                                              predict_history;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'b0;
    end else if (update_enable) begin
        predict_history <= next_history;
    end
    // else hold current state to avoid unnecessary toggling
end

endmodule