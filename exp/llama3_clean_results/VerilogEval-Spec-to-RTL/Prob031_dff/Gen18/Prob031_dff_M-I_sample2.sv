module TopModule(
    input clk,
    input d,
    input arst_n, // Asynchronous reset signal
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

// The always block is triggered on the positive edge of the clock or the asynchronous reset
// Non-blocking assignment is used for sequential logic
always @(posedge clk or negedge arst_n) begin
    if (~arst_n) begin
        // Reset the output q to 0 when the asynchronous reset is active (low)
        q <= 0;
    end else begin
        // The output q is assigned the value of input d
        q <= d;
    end
end

endmodule