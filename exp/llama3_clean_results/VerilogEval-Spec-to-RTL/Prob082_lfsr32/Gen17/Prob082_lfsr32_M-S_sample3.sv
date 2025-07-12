module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q <= {q[0] ^ q[21] ^ q[1] ^ q[30], q[31:1]}; // Update state register with correct tap application
    end
end

endmodule