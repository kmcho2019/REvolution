module TopModule (
    input        clk,
    input        rst_n,    // asynchronous active-low reset
    input  [7:0] d,
    output reg [7:0] q
);

    wire ce;  // clock enable

    assign ce = (d != q);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 8'b0;
        else if (ce)
            q <= d;
    end

endmodule