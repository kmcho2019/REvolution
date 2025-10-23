module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] counter_reg;
reg [3:0] output_reg;

always @(posedge clk) begin
    if (shift_ena) begin
        // Update shift register by shifting right and introducing new data bit
        shift_reg <= {data, shift_reg[3:1]};
    end else if (count_ena) begin
        // Decrement counter value
        if (counter_reg == 0) begin
            counter_reg <= shift_reg;
        end else begin
            counter_reg <= counter_reg - 1;
        end
    end
end

always @(*) begin
    // Update output register based on shift_ena and count_ena
    if (shift_ena) begin
        output_reg = shift_reg;
    end else if (count_ena) begin
        output_reg = counter_reg;
    end else begin
        output_reg = shift_reg;
    end
end

assign q = output_reg;

endmodule