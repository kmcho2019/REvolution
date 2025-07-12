// Shift Register module with active high asynchronous reset
module ShiftRegister(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 8'b0;
        end else begin
            shift_reg <= {shift_reg[6:0], d[0]};
        end
    end

    assign q = shift_reg;

endmodule

// TopModule using the Shift Register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    ShiftRegister shift_reg_inst(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule