module counter_12 (
    input  wire       rst_n,       // Asynchronous active-low reset
    input  wire       clk,         // Clock input
    input  wire       valid_count, // Enable counting
    output reg [3:0]  out          // 4-bit output count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'b0000;
        else
            out <= out + 1'b1;
    end
    // else hold current value when valid_count is low
end

endmodule