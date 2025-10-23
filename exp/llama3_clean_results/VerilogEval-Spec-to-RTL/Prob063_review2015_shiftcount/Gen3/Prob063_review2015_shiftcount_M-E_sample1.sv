module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] shift_reg;
reg [3:0] counter;

// Initialize the shift register and counter
initial begin
    shift_reg = 4'b0000;
    counter = 4'b0000;
end

// Shift register logic
always @(posedge clk) begin
    if (shift_ena) begin
        shift_reg <= {data, shift_reg[3:1]};
    end
end

// Counter logic
always @(posedge clk) begin
    if (count_ena) begin
        if (counter == 0) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter - 1;
        end
    end
end

// Multiplexer to select between shift register and counter
always @(posedge clk) begin
    if (shift_ena) begin
        q <= shift_reg;
    end else if (count_ena) begin
        q <= counter;
    end else begin
        q <= q; // Hold the current value
    end
end

endmodule