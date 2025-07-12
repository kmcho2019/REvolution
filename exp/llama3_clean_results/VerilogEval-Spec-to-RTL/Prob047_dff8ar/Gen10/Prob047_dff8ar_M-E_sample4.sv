// Shift Register module with active high asynchronous reset
module ShiftRegister(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] sr_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            sr_reg <= 8'b0;
        end else begin
            sr_reg <= {d[7:1], d[0]};
        end
    end

    assign q = sr_reg;

endmodule

// TopModule with a shift register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    ShiftRegister sr(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule