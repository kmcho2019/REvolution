module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

always @(posedge clk) begin
    // Using non-blocking assignment for clarity and potential expansion of the sequential logic
    q <= d;
end

endmodule