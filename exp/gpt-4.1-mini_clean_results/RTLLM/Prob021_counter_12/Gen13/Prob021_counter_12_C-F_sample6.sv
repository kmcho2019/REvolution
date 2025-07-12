module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_count;
wire terminal_count;

// Terminal count detection using simple equality check
assign terminal_count = (out == 4'd11);

// Combinational logic for next count value
always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_count = 4'b0000;
        else
            next_count = out + 1'b1;
    end else begin
        next_count = out;
    end
end

// Sequential logic with synchronous active-low reset
always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_count;
end

endmodule