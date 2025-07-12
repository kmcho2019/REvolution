// Improved Shift Register module with active high asynchronous reset
module ShiftRegister(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;
    reg [7:0] prev_d;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
            prev_d <= 8'b0;
        end else if (d != prev_d) begin
            q_reg <= d;
            prev_d <= d;
        end else begin
            prev_d <= prev_d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with the improved Shift Register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    ShiftRegister sr(.clk(clk),.areset(areset),.d(d),.q(q));

endmodule