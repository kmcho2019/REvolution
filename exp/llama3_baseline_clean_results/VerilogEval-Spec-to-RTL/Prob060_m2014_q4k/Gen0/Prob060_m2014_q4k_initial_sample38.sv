module TopModule(
    input        clk,
    input        resetn,
    input        in,
    output       out
);

reg [3:0] d_ff;

always @(posedge clk) begin
    if (!resetn) begin
        d_ff <= 4'd0; // Synchronous reset
    end else begin
        d_ff <= {in, d_ff[3:1]}; // Shift input into the first flop and shift other flops
    end
end

assign out = d_ff[0]; // Output is the value of the last flop

endmodule