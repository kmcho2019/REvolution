module TopModule (
    input clk,
    input rst,       // synchronous active-high reset
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst)
            q <= 8'b0;  // initialize all flip-flops to 0 on reset
        else
            q <= d;     // capture input d on rising clock edge
    end

endmodule