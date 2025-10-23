module TopModule(
    input         clk,
    input  [7:0]  in,
    output [7:0]  pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input vector
reg [7:0] pedge_reg; // Register to store the output vector

// Sequential logic to update the previous state of the input vector
always @(posedge clk) begin
    prev_in <= in;
    pedge_reg <= (in & (~prev_in)); // Detect 0 to 1 transitions and set output bits
end

// Combinatorial logic to drive the output vector
assign pedge = pedge_reg;

endmodule