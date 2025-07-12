module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] shift_reg;
    wire [2:0] select = {A, B, C};

    // Shift register update: on positive clock edge, shift in S if enable is high
    always @(posedge clk) begin
        if (enable)
            shift_reg <= {shift_reg[6:0], S};
    end

    // Multiplexer output using direct indexing
    always @(*) begin
        Z = shift_reg[select];
    end

endmodule