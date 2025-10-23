module TopModule (
    input wire in,
    output reg out
);
    // Single-state state machine that acts as a wire
    always @(*) begin
        out = in;  // State machine "transition" simply passes input to output
    end
endmodule