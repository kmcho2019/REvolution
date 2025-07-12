module counter_12(
    input rst_n,  // Asynchronous active low reset
    input clk,    // Clock signal
    input valid_count,  // Enable counting signal
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Asynchronous reset
        out <= 4'b0000;
    end else if (valid_count) begin
        if (out == 4'd11) begin  // Check for wrap-around condition
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end
end

endmodule