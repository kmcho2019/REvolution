module TopModule (
    input clk,
    input d,
    output reg q
);
    // Sequential logic: capture d into q on rising clock edge
    always @(posedge clk) begin
        q <= d;
    end
endmodule