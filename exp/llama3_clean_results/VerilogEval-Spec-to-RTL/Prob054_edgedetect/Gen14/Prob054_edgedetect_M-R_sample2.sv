module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

// Register to hold the previous state of the input vector
reg [7:0] prev_state;

// Sequential block to update the previous state and detect positive edges
always @(posedge clk) begin
    // Update the previous state
    prev_state <= in;
    
    // Detect positive edge transitions and update the output
    pedge <= in & (~prev_state);
end

endmodule