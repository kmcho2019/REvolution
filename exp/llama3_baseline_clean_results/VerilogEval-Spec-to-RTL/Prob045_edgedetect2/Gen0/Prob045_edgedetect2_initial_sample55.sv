module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // Register to store previous input value
reg [7:0] anyedge_reg; // Register to store anyedge value

always @(posedge clk) begin
    // Calculate anyedge by checking for transitions
    anyedge_reg <= (in ^ prev_in);
    
    // Update previous input value
    prev_in <= in;
end

assign anyedge = anyedge_reg;

endmodule