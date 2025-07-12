module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always_comb begin
        next_state = 4'b0;
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = in ? 4'b0010 : 4'b0001; // A -> B or A
            state[1]: next_state = in ? 4'b0010 : 4'b0100; // B -> B or C
            state[2]: next_state = in ? 4'b1000 : 4'b0001; // C -> D or A
            state[3]: next_state = in ? 4'b0010 : 4'b0100; // D -> B or C
        endcase
    end

    assign out = state[3]; // Output is state D

endmodule