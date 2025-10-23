module counter_12 (
    input  wire       rst_n,       // Active low reset (asynchronous)
    input  wire       clk,         
    input  wire       valid_count, // Counting enable
    output reg [3:0]  out
);

// Asynchronous active-low reset, synchronous count with enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        out <= 4'b0000;
    else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    // else hold the count when valid_count is 0
end

endmodule