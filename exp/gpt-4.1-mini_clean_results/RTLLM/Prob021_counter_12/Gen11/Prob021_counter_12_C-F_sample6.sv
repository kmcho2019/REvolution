module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Terminal count detection using minimal bitwise logic for count == 11 (4'b1011)
wire terminal_count = out[3] & ~out[2] & out[1] & out[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count) begin
        if (terminal_count)
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    else
        out <= out; // hold current value when valid_count is low
end

endmodule