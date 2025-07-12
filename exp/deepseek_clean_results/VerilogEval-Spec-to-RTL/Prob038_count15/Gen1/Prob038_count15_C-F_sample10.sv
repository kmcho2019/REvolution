module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Clock gating control signal
wire count_enable = (q != 4'b1111) | reset;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (count_enable) begin
        q <= q + 4'b0001;
    end
end

endmodule