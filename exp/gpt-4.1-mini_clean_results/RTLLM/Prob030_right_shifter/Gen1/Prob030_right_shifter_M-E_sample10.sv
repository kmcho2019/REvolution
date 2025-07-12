module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

reg init_done;

always @(posedge clk) begin
    if (!init_done) begin
        q <= 8'b0;
        init_done <= 1'b1;
    end else begin
        q <= {d, q[7:1]};
    end
end

endmodule