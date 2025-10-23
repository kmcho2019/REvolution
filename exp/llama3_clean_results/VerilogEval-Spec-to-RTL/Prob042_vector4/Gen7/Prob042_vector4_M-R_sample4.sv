module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    localparam REPLICATION_FACTOR = 24; // Define the replication factor as a parameter
    assign out = { {REPLICATION_FACTOR{in[7]}}, in }; // Use the parameter for replication
    
    // This structure remains simple and efficient, similar to the original,
    // but now has a parameter for the replication factor, making it slightly more flexible.
endmodule