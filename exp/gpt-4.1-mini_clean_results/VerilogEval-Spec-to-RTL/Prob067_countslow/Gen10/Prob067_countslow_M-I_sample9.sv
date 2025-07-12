module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Use an enable signal that is high during reset or slowena to control counting and reduce toggling
wire count_enable = reset | slowena;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (count_enable) begin
        if (q == 4'd9)
            q <= 4'd0;
        else
            q <= q + 4'd1;
    end
    // else hold q
end

endmodule