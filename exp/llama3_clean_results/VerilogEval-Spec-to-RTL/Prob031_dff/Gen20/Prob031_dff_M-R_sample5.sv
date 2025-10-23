module TopModule #(
    parameter WIDTH = 1 // Default width of the flip-flop
)(
    input clk,
    input rst_n, // Active low reset
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

// Attribute to specify low power optimization
(* power_opt = "high" *) 

// Attribute to enable clock gating for low power
(* enable_clock_gating = "true" *) 

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        q <= 0;
    end else begin
        // Normal operation
        q <= d;
    end
end

endmodule