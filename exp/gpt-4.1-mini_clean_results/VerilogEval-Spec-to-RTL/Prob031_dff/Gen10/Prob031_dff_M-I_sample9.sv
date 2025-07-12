module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Update q only if d differs from current q to reduce unnecessary toggling and save power
    always @(posedge clk) begin
        if (d != q) 
            q <= d;
    end
endmodule