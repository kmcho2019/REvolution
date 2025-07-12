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

    // Shift left on enable: S shifts into Q[0] = shift_reg[7], MSB first
    always @(posedge clk) begin
        if (enable)
            shift_reg <= {shift_reg[6:0], S};
    end

    // Compute adjusted select to map {A,B,C} to shift_reg index, since Q[0] = shift_reg[7]
    // Z = shift_reg[7 - select]
    wire [2:0] adj_select = 3'd7 - select;

    assign Z = shift_reg[adj_select];

endmodule