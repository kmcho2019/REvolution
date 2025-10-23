module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_out;
wire terminal_count;

// Terminal count detection when out == 11 (4'd11)
assign terminal_count = (out == 4'd11);

// Combinational next state logic based on valid_count and terminal_count
always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_out = 4'b0000;
        else
            next_out = out + 1;
    end else begin
        next_out = out;  // Hold current count when valid_count is low
    end
end

// Sequential logic with asynchronous active-low reset and enable by valid_count
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_out;
end

endmodule