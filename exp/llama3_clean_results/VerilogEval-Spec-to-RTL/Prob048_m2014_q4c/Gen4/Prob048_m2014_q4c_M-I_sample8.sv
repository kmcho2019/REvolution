module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);
// Attribute to potentially influence synthesis for better area and power
(* keep_hierarchy = "yes" *) 
always @(posedge clk) begin
    if (r) q <= 1'b0; // Explicitly define the reset value for clarity
    else q <= d;
end

endmodule