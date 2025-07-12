module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

    logic [7:0] shift_reg;

    always_ff @(posedge clk) begin
        if (reset) shift_reg <= 8'd0;
        else begin
            shift_reg[7:1] <= shift_reg[6:0];
            shift_reg[0] <= d[0];
        end
    end

    assign q = shift_reg;

endmodule