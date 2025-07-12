module TopModule (
    input        clk,
    input        rst,  // asynchronous active-high reset
    input  [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule