module TopModule (
    input clk,
    input d,
    output reg q,
    input rst_n  // asynchronous active-low reset
);

parameter RESET_VALUE = 1'b0;  // configurable reset value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= RESET_VALUE;
    end else begin
        q <= d;
    end
end

endmodule