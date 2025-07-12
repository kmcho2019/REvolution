module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'
reg [7:0] pedge_reg; // Register to store the pedge output

// Initialize pedge_reg and prev_in to 0 at the start
initial begin
    pedge_reg = 0;
    prev_in = 0;
end

// Capture the previous state of 'in' and update pedge_reg on each clock cycle
always @(posedge clk) begin
    prev_in <= in; // Store the current state of 'in' in prev_in
    pedge_reg <= (prev_in == 0) & in; // Set pedge_reg to 1 where a 0 to 1 transition is detected
end

// Assign the pedge output
assign pedge = pedge_reg;

endmodule