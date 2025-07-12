// Improved version with considerations for PPA optimization
module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);
    // Attribute to guide synthesis tool for potential area optimization
    (* keep_hierarchy = "yes" *)
    always @(posedge clk) begin
        // Directly express the reset and normal operation
        q <= r ? 1'b0 : d;
    end
endmodule