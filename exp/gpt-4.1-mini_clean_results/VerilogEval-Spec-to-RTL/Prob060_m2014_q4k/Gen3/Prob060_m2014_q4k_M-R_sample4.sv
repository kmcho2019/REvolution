module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire [3:0] next_shift_reg;

    assign next_shift_reg = {shift_reg[2:0], in};

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= 4'b0000;
        else
            shift_reg <= next_shift_reg;
    end

    assign out = shift_reg[3];

endmodule