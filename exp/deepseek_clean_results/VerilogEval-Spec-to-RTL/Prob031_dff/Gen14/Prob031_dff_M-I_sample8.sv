module TopModule (
    input clk,
    input rstn,  // Active-low asynchronous reset
    input d,
    output reg q
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) q <= 1'b0;
    else       q <= d;
end

endmodule