module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] count;
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
        ena_reg <= 3'd0;
    end else begin
        // Increment the ones digit
        if (count[3:0] == 4'd9) begin
            count[3:0] <= 4'd0;
            ena_reg[0] <= 1'b1;
        end else begin
            count[3:0] <= count[3:0] + 1;
            ena_reg[0] <= 1'b0;
        end

        // Increment the tens digit
        if (ena_reg[0] && count[7:4] == 4'd9) begin
            count[7:4] <= 4'd0;
            ena_reg[1] <= 1'b1;
        end else if (ena_reg[0]) begin
            count[7:4] <= count[7:4] + 1;
            ena_reg[1] <= 1'b0;
        end else begin
            ena_reg[1] <= 1'b0;
        end

        // Increment the hundreds digit
        if (ena_reg[1] && count[11:8] == 4'd9) begin
            count[11:8] <= 4'd0;
            ena_reg[2] <= 1'b1;
        end else if (ena_reg[1]) begin
            count[11:8] <= count[11:8] + 1;
            ena_reg[2] <= 1'b0;
        end else begin
            ena_reg[2] <= 1'b0;
        end

        // Increment the thousands digit
        if (ena_reg[2] && count[15:12] == 4'd9) begin
            count[15:12] <= 4'd0;
        end else if (ena_reg[2]) begin
            count[15:12] <= count[15:12] + 1;
        end
    end
end

assign q = count;
assign ena = ena_reg;

endmodule