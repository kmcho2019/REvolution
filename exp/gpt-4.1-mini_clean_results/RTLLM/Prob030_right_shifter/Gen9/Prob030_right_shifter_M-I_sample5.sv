module right_shifter (
    input  wire       clk,
    input  wire       rst_n,  // active low synchronous reset
    input  wire       d,
    output reg  [7:0] q
);

always @(posedge clk) begin
    if (!rst_n)
        q <= 8'b0;
    else begin
        // Shift q right by 1, inserting d into MSB
        q <= {d, q[7:1]};
    end
end

endmodule