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

    reg [31:0] main_history;
    reg [31:0] shadow_history;
    reg use_shadow;

    // Clock gating for main history updates
    wire main_clk_en = predict_valid && !train_mispredicted;
    wire gated_clk = main_clk_en ? clk : 1'b0;

    // Main history (prediction path)
    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            main_history <= 32'b0;
        end else begin
            main_history <= {main_history[30:0], predict_taken};
        end
    end

    // Shadow history (correction path)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shadow_history <= 32'b0;
            use_shadow <= 1'b0;
        end else if (train_mispredicted) begin
            shadow_history <= {train_history[30:0], train_taken};
            use_shadow <= 1'b1;
        end else if (predict_valid) begin
            use_shadow <= 1'b0;
        end
    end

    // Output selection
    assign predict_history = use_shadow ? shadow_history : main_history;

endmodule