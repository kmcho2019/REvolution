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

    // Dual history registers
    reg [31:0] safe_history;  // Committed state
    reg [31:0] spec_history;  // Speculative state
    
    // Clock gating signal for spec_history
    wire spec_clk_en = predict_valid && !train_mispredicted;
    wire gated_clk;
    
    // Clock gating cell
    CLK_GATE clk_gate (
        .CK(clk),
        .EN(spec_clk_en),
        .ECK(gated_clk)
    );
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            safe_history <= 32'b0;
        end else if (train_mispredicted) begin
            safe_history <= {train_history, train_taken};
        end
    end
    
    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            spec_history <= 32'b0;
        end else begin
            spec_history <= {spec_history[30:0], predict_taken};
        end
    end
    
    // Handle misprediction case (overrides spec_history)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Handled in other always blocks
        end else if (train_mispredicted) begin
            spec_history <= {train_history, train_taken};
        end
    end

    // Output follows speculative state
    assign predict_history = spec_history;

endmodule