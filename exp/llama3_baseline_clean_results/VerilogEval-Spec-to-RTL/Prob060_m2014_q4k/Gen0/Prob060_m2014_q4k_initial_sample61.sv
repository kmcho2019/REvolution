module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] dffs; // internal signal for D flip-flops

always @(posedge clk) begin
    if (!resetn) begin
        dffs <= 4'b0000; // synchronous reset
    end else begin
        dffs <= {dffs[2:0], in}; // shift register operation
    end
end

assign out = dffs[3]; // output is the MSB of the shift register

endmodule