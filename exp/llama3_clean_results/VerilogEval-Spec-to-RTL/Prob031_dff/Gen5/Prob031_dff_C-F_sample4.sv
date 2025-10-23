module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) // Example attribute, adjust according to synthesis tool and design requirements

// Initialize q to a default value
initial q = 1'b0;

// Use an always block with a sensitivity list to the positive edge of the clock
always @(posedge clk) begin
    // Use non-blocking assignment to update q
    q <= d;
end

endmodule