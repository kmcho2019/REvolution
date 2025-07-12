module TopModule(
    input clk,
    input rst,       // synchronous active-high reset
    input en,        // enable signal
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (rst) 
            q <= 8'b0;
        else if (en)
            q <= d;
        // else retain previous value
    end

endmodule