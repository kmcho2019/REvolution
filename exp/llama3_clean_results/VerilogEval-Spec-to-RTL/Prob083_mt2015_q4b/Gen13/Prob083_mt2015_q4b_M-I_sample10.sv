module TopModule(
    input x,
    input y,
    output z
);
    // Original logic
    // assign z = !(x ^ y);
    
    // Alternative logic for potential optimization
    assign z = (x && y) || (!x && !y);
endmodule