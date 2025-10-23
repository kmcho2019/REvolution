module TopModule(
    input clk,
    input rst_n,  // active-low asynchronous reset
    input d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;  // reset to 0
        else
            q <= d;
    end
endmodule