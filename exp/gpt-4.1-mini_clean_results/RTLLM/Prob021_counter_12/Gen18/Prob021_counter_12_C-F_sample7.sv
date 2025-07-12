module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

wire terminal_count;
reg [3:0] next_out;

// Terminal count when out == 11 (decimal)
assign terminal_count = (out == 4'd11);

// Combinational logic for next state
always @(*) begin
    if (valid_count) begin
        if (terminal_count)
            next_out = 4'b0000;
        else
            next_out = out + 1'b1;
    end else begin
        next_out = out; // Hold current value when counting not valid
    end
end

// Sequential logic: update output on clock edge with active-low reset
always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else
        out <= next_out;
end

endmodule