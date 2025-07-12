module TopModule (
    input clk,
    input d,
    output reg q,
    input rst_n  // Optional asynchronous reset (active low)
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        q <= 1'b0;
    else 
        q <= d;
end

endmodule