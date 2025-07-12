// Novel solution using explicit state machine and separate conditions for load and shift
module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    // Load operation
    if (L) begin
        Q <= R;
    end else if (E) begin
        // Shift operation
        Q <= w;
    end else begin
        // Hold current state if neither load nor shift is enabled
        Q <= Q;
    end
end

endmodule