module TopModule(
    input clk,
    input rst_n,  // Active low reset signal
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) 

// The always block is triggered on the positive edge of the clock or the active low reset signal
// Non-blocking assignment is used for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the output q to 0 when the reset signal is active low
        q <= 0;
    end else begin
        // The output q is assigned the value of input d on the positive edge of the clock
        q <= d;
    end
end

endmodule