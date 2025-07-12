module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q;

initial q = 4'd4; // initialize q to 4 as per the given simulation waveforms

always @(posedge clk) begin
    if (!a) begin // increment q only when a is low
        if (q == 3'd7) begin // if q is 7, reset it to 0
            q <= 3'd0;
        end else begin
            q <= q + 1'b1;
        end
    end
end

endmodule