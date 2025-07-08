module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

reg [31:0] history_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_reg <= 32'b0;
    end else if (train_mispredicted) begin
        // Load history: upper 31 bits from train_history[31:1], LSB from train_taken
        // According to spec, train_history is the history before the mispredicted branch,
        // so we take bits [31:1] and append train_taken at bit 0.
        // But the problem states train_history is 32 bits, concatenated with train_taken.
        // Actually, it says: history after completion = train_history (which is before mispredicted branch) concatenated with train_taken.
        // Since predict_history[0] is youngest branch, the LSB is the youngest branch.
        // So we shift train_history left by 1 and insert train_taken at bit 0.
        // However, the spec says "train_history concatenated with train_taken". This usually means {train_history, train_taken}, i.e., train_taken as the LSB after train_history.
        // But as predict_history is 32 bits, we must fit into 32 bits.
        // So the "history after completion" is train_history (32 bits) shifted left by 1 + train_taken? That would be 33 bits.
        // To fit, we need to remove the oldest bit (MSB) to keep 32 bits.
        // So final value is {train_history[30:0], train_taken} to keep 32 bits, or we take train_history[31:1] + train_taken as LSB.
        // But since the spec says train_history concatenated with train_taken, that implies 33 bits.
        // We must drop the oldest bit to keep 32 bits.
        // Therefore:
        history_reg <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
        history_reg <= {history_reg[31:1], predict_taken};
    end
end

assign predict_history = history_reg;

endmodule