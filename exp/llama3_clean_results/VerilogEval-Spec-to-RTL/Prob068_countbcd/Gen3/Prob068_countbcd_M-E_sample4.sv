module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] bcd_reg;
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        bcd_reg <= 0;
        ena_reg <= 0;
    end else begin
        reg [15:0] next_bcd;
        reg [2:0] next_ena;

        // Calculate the next BCD value
        next_bcd = bcd_reg + 1;

        // Check for carry-out from each digit
        next_ena[0] = (bcd_reg[3:0] == 9) ? 1 : 0;
        next_ena[1] = (bcd_reg[7:4] == 9 && next_ena[0]) ? 1 : 0;
        next_ena[2] = (bcd_reg[11:8] == 9 && next_ena[1]) ? 1 : 0;

        // Update the BCD register
        if (next_bcd[3:0] > 9) begin
            bcd_reg[3:0] <= 0;
            bcd_reg[7:4] <= bcd_reg[7:4] + 1;
        end else if (next_bcd[7:4] > 9) begin
            bcd_reg[7:4] <= 0;
            bcd_reg[11:8] <= bcd_reg[11:8] + 1;
        end else if (next_bcd[11:8] > 9) begin
            bcd_reg[11:8] <= 0;
            bcd_reg[15:12] <= bcd_reg[15:12] + 1;
        end else begin
            bcd_reg <= next_bcd;
        end

        // Update the enable signals
        ena_reg <= next_ena;
    end
end

assign q = bcd_reg;
assign ena = ena_reg;

endmodule