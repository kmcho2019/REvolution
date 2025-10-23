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

    reg [31:0] history_reg;
    wire gated_clk;
    wire update_needed = predict_valid | train_mispredicted;
    
    // Clock gating cell
    CLKGATE_X1 clk_gate (
        .CK(clk),
        .E(update_needed),
        .ECK(gated_clk)
    );
    
    // Pre-compute shift values
    wire [31:0] predicted_history = {history_reg[30:0], predict_taken};
    wire [31:0] corrected_history = {train_history[30:0], train_taken};
    
    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            // Priority encoded mux
            case ({train_mispredicted, predict_valid})
                2'b10: history_reg <= corrected_history;
                2'b01: history_reg <= predicted_history;
                default: history_reg <= history_reg;
            endcase
        end
    end

    assign predict_history = history_reg;

endmodule