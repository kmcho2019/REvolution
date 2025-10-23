// Improved Verilog code with synthesis attributes for optimization
module TopModule(
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up
);

// Apply synthesis attributes to optimize for area and power
(* synthesisKeeper = "true" *) // Prevent optimization of these nets
(* keep_hierarchy = "yes" *) // Preserve module hierarchy for optimization
assign left = (scancode == 16'he06b)? 1'b1 : 1'b0;
assign down = (scancode == 16'he072)? 1'b1 : 1'b0;
assign right = (scancode == 16'he074)? 1'b1 : 1'b0;
assign up = (scancode == 16'he075)? 1'b1 : 1'b0;

endmodule