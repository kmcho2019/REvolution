module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // Enumerated state type for clarity
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Sequential logic: state and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends solely on current state
            out <= (next_state == D) ? 1'b1 : 1'b0;
        end
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

endmodule