module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

reg [3:0] next_count;

// Combinational logic for next count value
always @(*) begin
    if (valid_count) begin
        if (out == 4'd11)
            next_count = 4'b0000;
        else
            next_count = out + 1;
    end else begin
        next_count = out;
    end
end

// Sequential logic with synchronous reset and clock enable style update
always @(posedge clk) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count)
        out <= next_count;
    // else retain current out to reduce unnecessary toggling
end

endmodule