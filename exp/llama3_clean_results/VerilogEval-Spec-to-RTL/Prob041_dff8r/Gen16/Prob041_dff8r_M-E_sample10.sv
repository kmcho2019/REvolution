module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    logic [7:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) shift_reg <= '0;
        else begin
            shift_reg[7] <= d[0];
            shift_reg[6] <= d[1];
            shift_reg[5] <= d[2];
            shift_reg[4] <= d[3];
            shift_reg[3] <= d[4];
            shift_reg[2] <= d[5];
            shift_reg[1] <= d[6];
            shift_reg[0] <= d[7];
        end
    end

    assign q = shift_reg;

endmodule