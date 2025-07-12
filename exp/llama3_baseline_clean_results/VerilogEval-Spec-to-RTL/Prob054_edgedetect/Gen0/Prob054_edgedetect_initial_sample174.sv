module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    // Update the previous state of the input vector
    prev_in <= in;
    
    // Detect positive edge transitions and set the output vector accordingly
    pedge <= (in & (~prev_in));
end

endmodule