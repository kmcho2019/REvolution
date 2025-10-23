module TopModule (
    input clk,
    input rst_n,       // Asynchronous active-low reset added for initialization
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 8'b0;
        else
            q <= d;
    end

endmodule