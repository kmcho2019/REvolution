module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly assigning the result to f for efficiency, with a comment to enhance readability.
// The condition (~x3 & x2) represents the scenario where x3 is low and x2 is high,
// and the condition (x3 & x1) represents the scenario where x3 is high and x1 is high.
assign f = (~x3 & x2) | (x3 & x1); // Output f is true if either condition is met

endmodule