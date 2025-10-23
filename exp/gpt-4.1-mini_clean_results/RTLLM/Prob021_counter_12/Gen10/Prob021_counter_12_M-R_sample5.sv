module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

    reg [3:0] next_out;

    // Combinational block to calculate next counter value
    always @(*) begin
        if (out == 4'd11)
            next_out = 4'd0;
        else
            next_out = out + 1'b1;
    end

    // Sequential block to update out on clock edge with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            out <= 4'd0;
        else if (valid_count)
            out <= next_out;
        else
            out <= out; // Hold current count when valid_count is 0
    end

endmodule