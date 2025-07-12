module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [10:0] shift_reg; // Extra bit for timeout detection

    // Binary to one-hot conversion during load
    wire [10:0] one_hot = (1 << data);

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= one_hot;
        end else begin
            shift_reg <= {shift_reg[9:0], 1'b0};
        end
    end

    assign tc = (shift_reg[10] == 1'b1);

endmodule