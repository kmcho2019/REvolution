module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 
// Attribute to specify low power optimization
(* power_opt = "high" *) 
// Attribute to enable clock gating for low power
(* enable_clock_gating = "true" *) 

always_ff @(posedge clk) begin
    // Non-blocking assignment is used for clarity and potential expansion of the sequential logic
    q <= d;
end

endmodule