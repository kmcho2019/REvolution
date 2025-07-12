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

    // Prepare candidate next states
    wire [31:0] loaded_history = {train_history[30:0], train_taken};
    wire [31:0] shifted_history = {history[30:0], predict_taken};

    // Select next state based on priority: misprediction load > prediction shift > hold
    wire update_load = train_mispredicted;
    wire update_shift = !train_mispredicted && predict_valid;

    wire [31:0] next_history = update_load ? loaded_history :
                               update_shift ? shifted_history :
                               history;

    // Generate bitwise clock enables where next differs from current
    wire [31:0] bit_clk_en = (next_history ^ history) & {32{update_load || update_shift}};

    // Individual bits update only if bit_clk_en set, else hold
    // Using clock gating via gating the enable of each bit

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : history_bits
            always @(posedge clk or posedge areset) begin
                if (areset) begin
                    history[i] <= 1'b0;
                end else if (bit_clk_en[i]) begin
                    history[i] <= next_history[i];
                end
                // else retain current bit (no toggle)
            end
        end
    endgenerate

    assign predict_history = history;

endmodule