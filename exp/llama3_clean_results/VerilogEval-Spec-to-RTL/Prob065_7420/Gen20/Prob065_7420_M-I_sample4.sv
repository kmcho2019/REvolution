// Directly use a single module for the 7420 chip's functionality, incorporating synthesis directives for optimization.
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
    // Perform NAND operations directly within the module.
    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);

    // Example synthesis directive to optimize for area and power.
    // The actual directive may vary depending on the synthesis tool being used.
    // For example, with Vivado, you might use attributes like (* area_opt *) or (* power_opt *).
    // Here, we assume a generic syntax for illustration purposes.
    (* optimize_for_area_and_power = "high" *)
    (* optimize_for_speed = "low" *)

endmodule