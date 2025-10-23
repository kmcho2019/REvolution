module TopModule (
    input x,
    input y,
    output z
);
    // Keep the same minimal implementation but add synthesis attributes
    // to guide the tool to use low-power cells if available
    (* use_low_power_cell = "true" *)
    wire y_not;
    
    (* use_low_power_cell = "true" *)
    assign y_not = ~y;
    
    (* use_low_power_cell = "true" *)
    assign z = x & y_not;
endmodule