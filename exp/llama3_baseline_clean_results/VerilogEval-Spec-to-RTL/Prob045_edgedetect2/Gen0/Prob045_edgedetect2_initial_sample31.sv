module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    // Store the current input in the previous state register
    prev_in <= in;
    
    // Detect any edge by comparing the current input with the previous state
    anyedge <= (in != prev_in);
end

endmodule