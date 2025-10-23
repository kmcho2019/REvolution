module TopModule(
    input clk,
    input d,
    input rst_n, // Active low reset
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

// The always block is triggered on the positive edge of the clock or the reset signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // If reset is active (low)
        q <= 1'b0; // Reset the output to 0
    end else begin
        // The output q is assigned the value of input d on the positive edge of the clock
        q <= d;
    end
end

endmodule