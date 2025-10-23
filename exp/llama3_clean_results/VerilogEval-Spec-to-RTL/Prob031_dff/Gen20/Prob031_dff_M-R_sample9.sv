module TopModule(
    input clk,
    input d,
    input rst_n, // Active-low reset signal
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) 

// The always block is triggered on the positive edge of the clock or the negation of the reset signal
always @(posedge clk or negedge rst_n) begin
    // If the reset signal is asserted (low), the output q is reset to 0
    if (!rst_n) begin
        q <= 1'b0;
    end else begin
        // The output q is assigned the value of input d on the positive edge of the clock
        q <= d;
    end
end

endmodule