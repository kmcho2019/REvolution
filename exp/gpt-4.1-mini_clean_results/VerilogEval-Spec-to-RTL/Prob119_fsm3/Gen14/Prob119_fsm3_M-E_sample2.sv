module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding (4 bits)
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic derived from transition table:
    // State A: next = in? B : A
    // State B: next = in? B : C
    // State C: next = in? D : A
    // State D: next = in? B : C

    always @(*) begin
        // default next_state = 4'b0000 to catch errors
        next_state = 4'b0000;

        case (1'b1)
            state[0]: begin // A
                next_state = in ? B : A;
            end
            state[1]: begin // B
                next_state = in ? B : C;
            end
            state[2]: begin // C
                next_state = in ? D : A;
            end
            state[3]: begin // D
                next_state = in ? B : C;
            end
            default: begin
                next_state = A; // reset unknown state to A
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Moore output: 1 only in state D (one-hot D is bit 3)
    assign out = state[3];

endmodule