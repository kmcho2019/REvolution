module TopModule (
    input clk,
    input resetn,
    input in,
    output out,
    input enable // Added for power optimization (tie high if unused)
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else if (enable) begin // Clock gating condition
            shift_reg <= {shift_reg[2:0], in};
        end
    end

    assign out = shift_reg[3];

endmodule