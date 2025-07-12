module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  out
);

    // State encoding: 1'b0 = A, 1'b1 = B
    reg state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            1'b1: // B
                if (in == 1'b0)
                    next_state = 1'b0; // A
                else
                    next_state = 1'b1; // B
            1'b0: // A
                if (in == 1'b0)
                    next_state = 1'b1; // B
                else
                    next_state = 1'b0; // A
            default:
                next_state = 1'b1; // Default to B if undefined state
        endcase
    end

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (reset)
            state <= 1'b1; // Reset to B
        else
            state <= next_state;
    end

    // Output logic (Moore FSM: depends only on state)
    always @(*) begin
        case(state)
            1'b1: out = 1'b1; // B: out=1
            1'b0: out = 1'b0; // A: out=0
            default: out = 1'b1;
        endcase
    end

endmodule