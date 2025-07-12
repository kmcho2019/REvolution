module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] Q;

    // Internal gated clock
    wire gated_clk = clk & enable;

    // Shift register: shift only when enable is high by clock gating
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end

    // Multiplexer output selecting Q indexed by ABC as a 3-bit number
    wire [2:0] addr = {A, B, C};
    assign Z = Q[addr];

endmodule