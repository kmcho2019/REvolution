module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    integer i;
    // Shift all bits right by one
    for (i = 0; i < 7; i = i + 1) begin
        q[i] <= q[i+1];
    end
    // Load input bit d into MSB
    q[7] <= d;
end

endmodule