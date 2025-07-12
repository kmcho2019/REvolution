module TopModule (
    output one
);
    // Use minimum drive strength (technology dependent)
    (* drive_strength = "1" *) 
    assign one = 1'b1;
    
    // Alternative structural implementation
    // pullup (one);  // If technology supports direct pull-up
endmodule