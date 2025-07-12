module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg = 0; // Initialize shift register to 0
reg [3:0] count_reg = 0; // Initialize count register to 0

// Shift register logic
always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end
end

// Count register logic
always @(posedge clk) begin
    if (count_ena) begin
        if (count_reg == 0) begin
            count_reg <= 0;
        end else begin
            count_reg <= count_reg - 1;
        end
    end
end

// Multiplexer to select output
always @(posedge clk) begin
    if (shift_ena) begin
        q <= shift_reg;
    end else if (count_ena) begin
        q <= count_reg;
    end else begin
        q <= shift_reg; // Default to shift register value
    end
end

endmodule