module TopModule(
    input clk, 
    input reset, 
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
        ena_reg <= 3'b0;
    end else begin
        // Calculate enables
        ena_reg[0] <= (ones == 4'd9);
        ena_reg[1] <= (tens == 4'd9) && ena_reg[0];
        ena_reg[2] <= (hundreds == 4'd9) && ena_reg[1];

        // Update counters
        if (ena_reg[0]) begin
            ones <= 4'd0;
        end else begin
            ones <= ones + 1'b1;
        end

        if (ena_reg[0] && ena_reg[1]) begin
            tens <= 4'd0;
        end else if (ena_reg[0]) begin
            tens <= tens + 1'b1;
        end

        if (ena_reg[1] && ena_reg[2]) begin
            hundreds <= 4'd0;
        end else if (ena_reg[1]) begin
            hundreds <= hundreds + 1'b1;
        end

        if (ena_reg[2]) begin
            thousands <= thousands + 1'b1;
            if (thousands == 4'd10) begin
                thousands <= 4'd0;
            end
        end
    end
end

assign ena = ena_reg;
assign q = {thousands, hundreds, tens, ones};

endmodule