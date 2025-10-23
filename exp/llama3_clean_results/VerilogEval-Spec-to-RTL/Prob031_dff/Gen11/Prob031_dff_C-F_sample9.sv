module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) // Example attribute, adjust according to synthesis tool and design requirements

always @(posedge clk) begin
    q <= d; // Non-blocking assignment is used for clarity and to follow best practices for sequential logic
end

endmodule