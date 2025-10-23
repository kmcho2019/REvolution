module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using a multiplexer-based approach to implement the logic
assign f = x3 ? x1 : x2;

endmodule