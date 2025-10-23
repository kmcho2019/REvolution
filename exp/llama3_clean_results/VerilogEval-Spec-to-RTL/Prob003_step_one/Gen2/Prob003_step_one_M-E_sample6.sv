module TopModule #(
    parameter WIDTH = 1
)(
    output [WIDTH-1:0] one
);
    // Use a replication operator to generate a vector of ones for the output
    assign one = {WIDTH{1'b1}};
endmodule