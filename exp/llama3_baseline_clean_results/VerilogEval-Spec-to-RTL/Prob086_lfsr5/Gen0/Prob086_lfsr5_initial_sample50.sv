module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        q <= 5'b00001; // reset to 1
    end else begin
        q <= {q[3] ^ q[0], q[4:1]}; // shift right with taps at 5 and 3
    end
end

endmodule