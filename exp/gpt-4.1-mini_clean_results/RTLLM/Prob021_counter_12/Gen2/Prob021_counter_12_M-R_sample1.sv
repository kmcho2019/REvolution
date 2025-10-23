module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

wire terminal_count;
reg [3:0] next_count;

// Terminal count detection using bitwise logic: 11 = 4'b1011
assign terminal_count = out[3] & ~out[2] & out[1] & out[0];

// Combinational logic to determine the next count value
always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_count = 4'b0000;
        else
            next_count = out + 1;
    end else begin
        next_count = out;
    end
end

// Sequential logic: update the count on the rising edge of the clock
always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_count;
end

endmodule