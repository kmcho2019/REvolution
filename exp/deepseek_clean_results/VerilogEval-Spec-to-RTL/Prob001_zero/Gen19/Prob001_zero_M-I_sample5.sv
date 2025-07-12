module TopModule (
    output zero
);
    // This module outputs a constant LOW signal using low-power driver
    (* use_low_power_driver *)
    assign zero = 1'b0;
endmodule