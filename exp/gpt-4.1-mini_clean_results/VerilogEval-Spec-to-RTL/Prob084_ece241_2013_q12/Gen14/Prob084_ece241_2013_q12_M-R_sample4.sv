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

    // Shift register: on clk rising edge and enable, shift right and load S into Q[0]
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Multiplexer output selecting Q indexed by ABC as a 3-bit number
    wire [2:0] addr = {A, B, C};
    assign Z = Q[addr];

endmodule