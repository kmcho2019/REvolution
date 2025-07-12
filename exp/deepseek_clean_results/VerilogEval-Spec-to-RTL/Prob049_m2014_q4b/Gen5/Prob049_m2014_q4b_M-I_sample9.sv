module TopModule (
    input clk,
    input ar_n,  // active-low async reset
    input d,
    output reg q
);

parameter RESET_VALUE = 1'b0;

always @(posedge clk or negedge ar_n) begin
    if (!ar_n) q <= RESET_VALUE;
    else       q <= d;
end

endmodule