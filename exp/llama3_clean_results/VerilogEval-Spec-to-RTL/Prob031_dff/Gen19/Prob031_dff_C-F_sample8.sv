module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) 

// Attribute to specify low power optimization
(* power_opt = "high" *) 

// Attribute to enable clock gating for low power
(* enable_clock_gating = "true" *) 

// Sequential logic using always block for positive edge triggered D flip-flop
always @(posedge clk) begin
    // Use non-blocking assignment for sequential logic clarity and expandability
    q <= d;
end

endmodule