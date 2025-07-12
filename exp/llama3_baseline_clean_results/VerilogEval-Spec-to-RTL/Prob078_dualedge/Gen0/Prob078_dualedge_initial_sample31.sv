module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_edge; // To detect rising edge
reg prev_clk; // To store previous clock value

always @(posedge clk or negedge clk) begin
    prev_clk <= clk;
end

always @(*) begin
    clk_edge = (clk!= prev_clk); // Rising or falling edge detection
end

always @(posedge clk_edge) begin
    q <= d;
end

initial begin
    prev_clk = 1'b0; // Initialize previous clock value
end

endmodule