module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] history;
reg [4:0]  ptr;

// Control module
wire shift_enable;
wire update_enable;
wire [31:0] new_history;
assign shift_enable = predict_valid & ~train_mispredicted;
assign update_enable = train_mispredicted;
assign new_history = (update_enable)? {train_history, train_taken} : 
                     (shift_enable)? {history[30:0], predict_taken} : history;

// Ring buffer module
always @(posedge clk or posedge areset) begin
    if (areset) begin
        history <= 0;
        ptr <= 0;
    end else begin
        if (update_enable) begin
            history <= new_history;
            ptr <= 0;
        end else if (shift_enable) begin
            history <= {history[30:0], predict_taken};
            ptr <= ptr + 1;
        end
    end
end

assign predict_history = history;

endmodule