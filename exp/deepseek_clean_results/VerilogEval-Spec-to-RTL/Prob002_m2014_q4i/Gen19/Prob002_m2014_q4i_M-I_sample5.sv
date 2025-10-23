/*
 * TopModule - Outputs a constant logic low (0)
 * Optimal implementation with zero timing paths and minimal power/area
 */
module TopModule (
    output out
);
    parameter CONST_VAL = 1'b0;  // Allows easy modification if requirements change
    
    assign out = CONST_VAL;
endmodule