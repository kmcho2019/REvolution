// Define the TopModule with input and output ports
module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output data
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) 

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment is used for sequential logic
    q <= d; // Assign input d to output q on the positive clock edge
end

endmodule