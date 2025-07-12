module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] count_reg;

// Initialize the registers
initial begin
    shift_reg = 4'b0000;
    count_reg = 4'b0000;
end

// Shift register logic
always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end
end

// Down counter logic
always @(posedge clk) begin
    if (count_ena) begin
        if (count_reg == 4'b0000) begin
            count_reg <= 4'b0000; // handle underflow
        end else begin
            count_reg <= count_reg - 1;
        end
    end
end

// Select between shift register and counter
always @(posedge clk) begin
    if (shift_ena) begin
        q <= shift_reg;
    end else if (count_ena) begin
        q <= count_reg;
    end
end

endmodule