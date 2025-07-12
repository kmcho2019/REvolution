module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    reg [3:0] shift_reg;
    reg enable;

    // Enable shift only if input changes or shift_reg changes,
    // to reduce switching power. For simplicity, shift every cycle here.
    // If desired, more complex gating logic could be added, but it may not
    // significantly reduce power for such a small design.

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], in};
    end

    assign out = shift_reg[3];

endmodule