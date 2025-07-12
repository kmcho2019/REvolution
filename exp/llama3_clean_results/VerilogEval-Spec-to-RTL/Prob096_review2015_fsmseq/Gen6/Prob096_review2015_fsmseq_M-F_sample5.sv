module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg;
reg seq_found;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
        seq_found <= 0;
        start_shifting <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        if (!seq_found && shift_reg == 4'b1101) begin
            seq_found <= 1;
        end else if (seq_found) begin
            // Do nothing, seq_found remains 1
        end
        start_shifting <= seq_found;
    end
end

endmodule