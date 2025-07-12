module TopModule(
    input clk,
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
// This can help the synthesis tool optimize the design for performance
(* max_freq = "1000.0" *) // Example attribute, adjust according to synthesis tool and design requirements

always @(posedge clk) begin
    q <= d;
end

endmodule