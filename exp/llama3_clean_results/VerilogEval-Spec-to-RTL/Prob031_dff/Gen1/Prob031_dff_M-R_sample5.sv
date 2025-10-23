module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

// Optional: Initializing q, though not necessary in most FPGA and ASIC flows
initial q = 1'b0;

endmodule