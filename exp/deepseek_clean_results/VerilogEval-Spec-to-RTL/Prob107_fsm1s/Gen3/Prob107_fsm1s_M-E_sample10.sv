module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b11; // Reset to state B (left bit=1)
        end else begin
            // Shift left and insert new bit based on input
            state_shift <= {state_shift[0], in ? state_shift[1] : ~state_shift[1]};
        end
    end

    assign out = state_shift[1]; // Output is the left bit

endmodule