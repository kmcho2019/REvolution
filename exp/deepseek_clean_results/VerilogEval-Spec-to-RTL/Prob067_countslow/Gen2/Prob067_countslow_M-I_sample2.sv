module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire count_enable = slowena && (reset == 1'b0);
wire wrap_around = q[3] && q[0];  // Detects 9 (1001) by checking bits 3 and 0

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (count_enable) begin
        if (wrap_around) begin
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule