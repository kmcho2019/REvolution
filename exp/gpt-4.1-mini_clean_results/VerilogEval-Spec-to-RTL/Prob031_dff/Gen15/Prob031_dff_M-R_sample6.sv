module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    // On every positive clock edge, capture the input d into q
    always @(posedge clk) begin
        q <= d;
    end

endmodule