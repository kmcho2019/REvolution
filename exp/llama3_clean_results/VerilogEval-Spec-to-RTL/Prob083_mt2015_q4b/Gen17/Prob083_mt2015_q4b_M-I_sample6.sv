module TopModule(
    input x,
    input y,
    output wire z // Explicitly defining z as a wire for clarity
);
    // Using the equality check for its simplicity and directness
    assign z = (x == y);
endmodule