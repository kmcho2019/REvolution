module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    reg [3:0] shift_reg;
    reg [3:0] count_reg;

    always @(posedge clk) begin
        // Shift register logic: shift in data MSB first
        if (shift_ena) begin
            shift_reg <= {shift_reg[2:0], data};
            q <= {shift_reg[2:0], data};
        end
        // Count down logic
        else if (count_ena) begin
            count_reg <= q - 1;
            q <= q - 1;
        end
        // Hold current state otherwise
        else begin
            shift_reg <= q;
            count_reg <= q;
            q <= q;
        end
    end

endmodule