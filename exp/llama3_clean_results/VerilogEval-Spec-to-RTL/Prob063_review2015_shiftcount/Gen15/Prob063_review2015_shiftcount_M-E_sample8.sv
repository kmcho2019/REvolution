module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] count_reg;

// Shift Register Module
always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end else begin
        shift_reg <= shift_reg;
    end
end

// Down Counter Module
always @(posedge clk) begin
    if (count_ena) begin
        if (count_reg == 4'b0) begin
            count_reg <= 4'b0; // Stop at zero
        end else begin
            count_reg <= count_reg - 1;
        end
    end else begin
        count_reg <= count_reg;
    end
end

// MUX to select between shift register and down counter
always @(posedge clk) begin
    if (shift_ena) begin
        q <= shift_reg;
    end else if (count_ena) begin
        q <= count_reg;
    end else begin
        q <= q; // Hold the current value
    end
end

endmodule