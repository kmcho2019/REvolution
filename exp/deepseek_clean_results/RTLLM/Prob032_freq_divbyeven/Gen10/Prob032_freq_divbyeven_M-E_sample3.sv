module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;

initial if (NUM_DIV < 2 || NUM_DIV%2 != 0) begin
    $error("NUM_DIV must be even and >= 2");
    $finish;
end

reg [NUM_DIV/2-1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= {1'b1, {(NUM_DIV/2-1){1'b0}}};
        clk_div <= 0;
    end
    else begin
        // Rotate right and update output
        shift_reg <= {shift_reg[0], shift_reg[NUM_DIV/2-1:1]};
        clk_div <= shift_reg[NUM_DIV/2-1];
    end
end

endmodule