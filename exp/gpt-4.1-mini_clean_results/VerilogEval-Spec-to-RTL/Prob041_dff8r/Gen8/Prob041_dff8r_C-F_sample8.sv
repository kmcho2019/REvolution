module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    // Only update q if reset asserted or input d differs from q to reduce unnecessary toggling (power optimization)
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;
        else if (d != q)
            q <= d;
    end
endmodule