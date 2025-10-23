module TopModule(
    input x,
    input y,
    output logic z
);
    // Retaining the efficient logic from the first example
    // This expression is concise and efficient, making it suitable for high-performance applications
    assign z = ~(x ^ y);
    
    // To minimize switching activity and reduce power consumption
    // Ensure that inputs x and y are stable and unnecessary transitions are avoided
    // This can be achieved by proper synchronization and buffering of inputs in the larger design context
endmodule