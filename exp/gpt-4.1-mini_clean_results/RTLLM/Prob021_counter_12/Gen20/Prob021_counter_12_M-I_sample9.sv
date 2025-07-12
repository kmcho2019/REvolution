module counter_12 (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       valid_count,
    output reg [3:0]  out
);

// Sequential logic for counter with direct comparison for terminal count
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'b0000;
        else
            out <= out + 1;
    end
    // else hold current count (no else branch needed since out is reg)
end

endmodule