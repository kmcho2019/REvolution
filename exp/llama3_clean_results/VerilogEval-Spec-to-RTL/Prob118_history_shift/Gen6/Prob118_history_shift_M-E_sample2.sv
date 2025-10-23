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

reg [30:0] shift_register;
reg        load_register;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_register <= 0;
        load_register <= 0;
    end else if (train_mispredicted) begin
        shift_register <= train_history[30:0];
        load_register <= train_taken;
    end else if (predict_valid) begin
        shift_register <= {shift_register[29:0], load_register};
        load_register <= predict_taken;
    end
end

assign predict_history = {shift_register, load_register};

endmodule