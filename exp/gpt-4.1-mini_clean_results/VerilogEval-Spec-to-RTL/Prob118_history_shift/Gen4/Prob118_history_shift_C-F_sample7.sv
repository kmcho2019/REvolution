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
    reg [31:0] next_history;
    wire load = train_mispredicted;
    wire shift = !train_mispredicted && predict_valid;
    wire update_enable = load || shift;

    // Construct the load and shift values
    wire [31:0] mispredicted_load = {train_history[30:0], train_taken};
    wire [31:0] predict_shifted  = {history[30:0], predict_taken};

    // Compute next state combinationally with priority
    always @(*) begin
        if (load) begin
            next_history = mispredicted_load;
        end else if (shift) begin
            next_history = predict_shifted;
        end else begin
            next_history = history;
        end
    end

    // Register update with asynchronous reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (update_enable) begin
            history <= next_history;
        end
        // else hold current value, reducing unnecessary toggling
    end

    assign predict_history = history;

endmodule