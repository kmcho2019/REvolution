module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b1) begin
        // do nothing, keep the current value of q
    end else begin
        // increment q by 1
        q <= (q + 1) % 8;
    end
end

initial begin
    q <= 3'b100; // initialize q to 4
end

endmodule