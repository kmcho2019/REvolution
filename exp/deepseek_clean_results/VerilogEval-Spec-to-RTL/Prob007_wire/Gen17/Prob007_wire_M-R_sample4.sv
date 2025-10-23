/*
 * TopModule - Alternative Wire Implementation
 * Description: Demonstrates equivalent wire connection using different syntax
 * Functionality: Identical to reference implementation (out = in)
 * PPA Identical: Same timing/power/area characteristics
 */
module TopModule (
    input  in,  // Input signal (implicit wire)
    output out  // Output signal (implicit wire)
);
    // Alternative syntax for wire connection
    assign out = in;
endmodule