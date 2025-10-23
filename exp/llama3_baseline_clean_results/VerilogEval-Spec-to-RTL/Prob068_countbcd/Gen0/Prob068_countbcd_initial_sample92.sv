module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_reg;

    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b000;
        end else begin
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena_reg[0] <= 1'b1;
            end else begin
                ones <= ones + 1'b1;
                ena_reg[0] <= 1'b0;
            end

            if (ena_reg[0] && tens == 4'd9) begin
                tens <= 4'd0;
                ena_reg[1] <= 1'b1;
            end else if (ena_reg[0]) begin
                tens <= tens + 1'b1;
                ena_reg[1] <= 1'b0;
            end else begin
                ena_reg[1] <= 1'b0;
            end

            if (ena_reg[1] && hundreds == 4'd9) begin
                hundreds <= 4'd0;
                ena_reg[2] <= 1'b1;
            end else if (ena_reg[1]) begin
                hundreds <= hundreds + 1'b1;
                ena_reg[2] <= 1'b0;
            end else begin
                ena_reg[2] <= 1'b0;
            end

            if (ena_reg[2] && thousands == 4'd9) begin
                thousands <= 4'd0;
            end else if (ena_reg[2]) begin
                thousands <= thousands + 1'b1;
            end
        end
    end

    assign q[3:0] = ones;
    assign q[7:4] = tens;
    assign q[11:8] = hundreds;
    assign q[15:12] = thousands;
    assign ena = ena_reg;

endmodule