module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always_comb begin
        casez (state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0001; // State A
            4'b0010: next_state = in ? 4'b0010 : 4'b0100; // State B
            4'b0100: next_state = in ? 4'b1000 : 4'b0001; // State C
            4'b1000: next_state = in ? 4'b0010 : 4'b0100; // State D
            default: next_state = 4'b0001; // Handle invalid states
        endcase
    end

    assign out = state[3]; // Output remains the same

endmodule