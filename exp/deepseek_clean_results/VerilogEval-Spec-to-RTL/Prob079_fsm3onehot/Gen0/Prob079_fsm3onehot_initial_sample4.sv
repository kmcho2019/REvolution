module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Output logic (Moore machine: output depends only on current state)
    assign out = (state == 4'b1000);  // Output 1 only in state D

    // Next state logic
    always @(*) begin
        case (state)
            4'b0001: next_state = in ? 4'b0010 : 4'b0001;  // A -> B if in=1, else stay A
            4'b0010: next_state = in ? 4'b0010 : 4'b0100;  // B -> B if in=1, else C
            4'b0100: next_state = in ? 4'b1000 : 4'b0001;  // C -> D if in=1, else A
            4'b1000: next_state = in ? 4'b0010 : 4'b0100;  // D -> B if in=1, else C
            default: next_state = 4'b0001;  // Handle unexpected states by going to A
        endcase
    end

endmodule