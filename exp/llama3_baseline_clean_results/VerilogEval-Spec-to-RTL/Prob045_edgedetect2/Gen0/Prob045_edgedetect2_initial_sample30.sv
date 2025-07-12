module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store previous input value

always @(posedge clk) begin
    // Update previous input value
    prev_in <= in;
    
    // Detect any edge transition
    anyedge <= prev_in ^ in;
end

endmodule