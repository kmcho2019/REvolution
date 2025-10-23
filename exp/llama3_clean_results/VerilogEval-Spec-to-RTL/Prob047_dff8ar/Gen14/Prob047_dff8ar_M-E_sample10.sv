// Shift Register D Flip-Flop module with active high asynchronous reset
module ShiftRegisterDFF(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] shift_reg [0:7];

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (int i = 0; i < 8; i++) begin
                shift_reg[i] <= 8'b0;
            end
        end else begin
            shift_reg[0] <= d;
            for (int i = 1; i < 8; i++) begin
                shift_reg[i] <= shift_reg[i-1];
            end
        end
    end

    assign q = shift_reg[7];

endmodule

// TopModule with Shift Register D Flip-Flop
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    ShiftRegisterDFF shift_dff(.clk(clk),.areset(areset),.d(d),.q(q));

endmodule