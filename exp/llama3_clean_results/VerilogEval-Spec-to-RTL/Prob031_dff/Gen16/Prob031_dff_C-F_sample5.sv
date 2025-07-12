module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 
// Attributes to guide the synthesis tool for low power and area optimization
(* power_optimization = "high" *)
(* area_optimization = "high" *)

always @(posedge clk) begin
    // Non-blocking assignment for clarity and potential expansion of sequential logic
    q <= d;
end

endmodule