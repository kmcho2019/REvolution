module TopModule(
    input clk,
    input d,
    output q
);

reg qFF1; // Register for positive edge flip-flop
reg qFF2; // Register for negative edge flip-flop

// Positive edge triggered flip-flop
always @(posedge clk)
    qFF1 <= d;

// Negative edge triggered flip-flop
always @(negedge clk)
    qFF2 <= d;

// Mux to select output based on clock edge
assign q = (clk) ? qFF1 : qFF2;

endmodule