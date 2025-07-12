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

reg [30:0] history_upper; // history[31:1]
reg        history_lsb;   // history[0]

wire [30:0] shifted_upper = {history_upper[29:0], history_lsb};
wire        shifted_lsb   = predict_taken;

wire [30:0] loaded_upper  = train_history[31:1];
wire        loaded_lsb    = train_taken;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_upper <= 31'b0;
        history_lsb   <= 1'b0;
    end else if (train_mispredicted) begin
        history_upper <= loaded_upper;
        history_lsb   <= loaded_lsb;
    end else if (predict_valid) begin
        history_upper <= shifted_upper;
        history_lsb   <= shifted_lsb;
    end
    // else hold current state
end

assign predict_history = {history_upper, history_lsb};

endmodule