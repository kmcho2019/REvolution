module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

// Internal register to store the previous input value
reg [7:0] prev_in;

// Initialize prev_in to a default value to avoid undefined behavior
initial begin
    prev_in = 8'b0;
end

// Detect any edge in the input signal 'in' and update 'anyedge' accordingly
always @(posedge clk) begin
    // Update 'prev_in' with the current input value
    prev_in <= in;
    
    // Calculate 'anyedge' by performing an XOR operation between 'in' and 'prev_in'
    anyedge <= in ^ prev_in;
end

endmodule