module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

always @(posedge clk) begin
    // Non-blocking assignment is not necessary here since it's the only statement
    // However, we keep it for clarity and potential expansion of the sequential logic
    q <= d;
end

endmodule