module TopModule(
    input clk,
    input d,
    input rst_n, // Active low synchronous reset
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

// The always block is triggered on the positive edge of the clock
// Non-blocking assignment is used for sequential logic
always @(posedge clk) begin
    if (!rst_n) begin
        // Reset the output q to 0 when reset is active
        q <= 1'b0;
    end else begin
        // The output q is assigned the value of input d
        q <= d;
    end
end

endmodule