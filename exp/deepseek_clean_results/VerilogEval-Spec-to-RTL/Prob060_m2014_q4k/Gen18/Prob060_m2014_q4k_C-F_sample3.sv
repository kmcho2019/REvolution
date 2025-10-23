module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter WIDTH = 4;
    reg [WIDTH-1:0] shift_reg;

    // Named intermediate signals for better debugging
    wire stage0 = shift_reg[0];
    wire stage1 = shift_reg[1];
    wire stage2 = shift_reg[2];
    wire stage3 = shift_reg[3];

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        end
    end

    assign out = shift_reg[WIDTH-1];

endmodule