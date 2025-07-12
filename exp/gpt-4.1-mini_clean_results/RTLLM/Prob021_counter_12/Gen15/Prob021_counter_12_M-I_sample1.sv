module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;

// Combinational next state logic using equality check for terminal count
always @(*) begin
    if (valid_count) begin
        if (out == 4'd11)
            next_out = 4'b0000;
        else
            next_out = out + 1'b1;
    end else begin
        next_out = out; // Hold current count when valid_count is low
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