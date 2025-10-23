module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // One-hot state encoding for 4 states
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state combinational logic using case on current state and input
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A; // Safety fallback
        endcase
    end

    // State register and output update on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= (next_state == D); // Output reflects Moore FSM output for next state
        end
    end

endmodule