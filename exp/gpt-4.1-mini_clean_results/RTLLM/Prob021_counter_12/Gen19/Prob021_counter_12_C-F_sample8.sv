module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire terminal_count;
reg [3:0] next_out;

// Terminal count detection when out == 11 (4'b1011)
assign terminal_count = out[3] & ~out[2] & out[1] & out[0];

// Next state logic
always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_out = 4'b0000;
        else
            next_out = out + 1'b1;
    end else begin
        next_out = out; // Hold current count when not enabled
    end
end

// Sequential logic with synchronous active-low reset
always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_out;
end

endmodule