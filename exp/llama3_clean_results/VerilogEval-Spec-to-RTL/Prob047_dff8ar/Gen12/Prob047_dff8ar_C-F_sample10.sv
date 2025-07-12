// Superior Shift Register module with active high asynchronous reset
module SuperiorShiftRegister(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0;
        end else begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule

// TopModule with the superior shift register
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    SuperiorShiftRegister ssr(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule