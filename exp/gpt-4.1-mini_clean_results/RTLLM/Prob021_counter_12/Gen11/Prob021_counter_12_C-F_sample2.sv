module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Terminal count detection for decimal 11 (4'b1011)
wire terminal_count = out[3] & ~out[2] & out[1] & out[0];

reg [3:0] next_count;

// Combinational logic for next count value
always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_count = 4'b0000;
        else
            next_count = out + 4'b0001;
    end else begin
        next_count = out;
    end
end

// Sequential logic: update out on rising edge of clk, async active-low reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_count;
end

endmodule