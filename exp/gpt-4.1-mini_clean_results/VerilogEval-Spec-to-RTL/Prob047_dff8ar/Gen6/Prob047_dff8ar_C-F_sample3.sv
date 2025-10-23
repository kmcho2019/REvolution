module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output reg [7:0] q
);
    // Asynchronous active-high reset, positive edge clocked 8-bit register
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule