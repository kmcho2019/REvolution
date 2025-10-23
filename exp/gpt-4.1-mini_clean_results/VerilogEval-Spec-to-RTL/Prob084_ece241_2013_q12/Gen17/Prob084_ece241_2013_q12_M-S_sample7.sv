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
    wire [2:0] select = {A, B, C};

    always @(posedge clk) begin
        if (enable)
            shift_reg <= {shift_reg[6:0], S};
    end

    assign Z = shift_reg[select];

endmodule