module TopModule (
    input  wire clk,  // added clock input
    input  wire d,
    input  wire ena,
    output reg  q
);

    always @(posedge clk) begin
        if (ena)
            q <= d;
    end

endmodule