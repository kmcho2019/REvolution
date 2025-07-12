module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output reg  [7:0]  q
);
    // Asynchronous active-high reset and positive edge clock triggered D flip-flops
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= d;
    end
endmodule