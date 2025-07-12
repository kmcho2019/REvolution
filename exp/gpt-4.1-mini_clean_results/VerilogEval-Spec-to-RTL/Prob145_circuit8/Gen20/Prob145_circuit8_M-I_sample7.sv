module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

// Synchronous reset omitted (no reset signal given); outputs initialize to 0 for simulation
// If unknown initial states are desired, remove the initial block

initial begin
    p = 0;
    q = 0;
end

always @(posedge clock) begin
    // Temporary variables to hold previous states for correct sequencing
    // Capture previous p before update to assign to q
    q <= p;
    p <= a & q;
end

endmodule