module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;  // Register to store the previous state of the input vector

// Sequential logic to update the previous state and detect edges
always @(posedge clk) begin
    anyedge <= in ^ prev_state;
    prev_state <= in;
end

endmodule