module TopModule (
    input clk,
    input rst_n,    // asynchronous active-low reset
    input d,
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;  // reset to 0
    end
    else begin
        q <= d;     // normal operation
    end
end

endmodule