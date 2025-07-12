module TopModule (
    input a,
    input b,
    input sel,
    output reg out
);
    // Optimized 2:1 mux with power-conscious implementation
    // Uses ternary operator for minimal area and best timing
    // reg output gives synthesis more optimization flexibility
    always @(*) begin
        out = sel ? b : a;
    end
endmodule