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

reg [31:0] history_ram[1:0];
reg [1:0] write_ptr;
reg [1:0] read_ptr;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        history_ram[0] <= 32'd0;
        history_ram[1] <= 32'd0;
        write_ptr <= 2'd0;
        read_ptr <= 2'd0;
    end else begin
        if (train_mispredicted) begin
            history_ram[write_ptr] <= {train_history, train_taken};
            write_ptr <= ~write_ptr;
        end else if (predict_valid) begin
            history_ram[write_ptr] <= {history_ram[read_ptr][30:0], predict_taken};
            write_ptr <= ~write_ptr;
        end
    end
end

always @(*) begin
    predict_history = history_ram[read_ptr];
end

endmodule