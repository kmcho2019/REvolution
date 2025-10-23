module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] shift_reg;

    // Shift register with Q[0] as LSB: shift left, shift_reg[0] gets S
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Use ABC as select index directly for multiplexing output
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule