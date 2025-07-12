module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Novel implementation using a different logical structure
// This approach aims to capture the same functionality with potentially different PPA characteristics
assign f = (x2 & ~x3) | (x1 & x3);

// Alternatively, considering a more structural approach with multiplexers or LUTs could provide insights into optimization possibilities
// However, given the simplicity of the current implementation, such approaches might not yield significant improvements without specific technology or synthesis considerations

endmodule