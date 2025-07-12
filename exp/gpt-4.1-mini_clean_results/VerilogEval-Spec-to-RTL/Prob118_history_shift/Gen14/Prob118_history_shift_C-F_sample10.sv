module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;

    // Determine when to update the history register
    wire load_enable  = train_mispredicted;
    wire shift_enable = !train_mispredicted && predict_valid;
    wire update_enable = load_enable || shift_enable;

    // Compute candidate values for loading or shifting history
    wire [31:0] loaded_history  = {train_history[30:0], train_taken};
    wire [31:0] shifted_history = {history[30:0], predict_taken};

    // Next history value based on priority: misprediction load > prediction shift > hold
    wire [31:0] next_history = load_enable ? loaded_history :
                              shift_enable ? shifted_history :
                              history;

    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else if (update_enable)
            history <= next_history;
        else
            history <= history; // hold current value
    end

    assign predict_history = history;

endmodule