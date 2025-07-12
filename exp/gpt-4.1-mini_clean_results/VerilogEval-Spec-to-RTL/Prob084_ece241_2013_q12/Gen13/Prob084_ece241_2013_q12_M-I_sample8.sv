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
    wire gated_clk;

    // Simple clock gating: gated_clk is active only when enable is high
    assign gated_clk = clk & enable;

    // Shift register with clock gating; shift left, S shifted into LSB
    always @(posedge gated_clk) begin
        // Since gated_clk is active only when enable=1, no need to check enable here
        shift_reg <= {shift_reg[6:0], S};
    end

    // Multiplexer select lines formed from ABC
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule