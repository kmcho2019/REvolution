module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is already quite optimized for this specific logic.
// However, we could consider rearranging the terms for potential better synthesis,
// though the impact might be minimal or negligible without specific technology details.
assign f = (x3 ? x1 : x2); // Conditional operator to possibly simplify the logic

endmodule