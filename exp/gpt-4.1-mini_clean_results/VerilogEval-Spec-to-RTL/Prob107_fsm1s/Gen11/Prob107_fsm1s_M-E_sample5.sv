module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam [1:0]
        B = 2'b00,
        A = 2'b01;

    reg [1:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic with case statement
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: next_state = B;
        endcase
    end

    // Registered Moore output assigned on clock edge to reduce glitches
    always @(posedge clk) begin
        if (reset)
            out <= 1'b1;  // Output for state B after reset
        else begin
            case(state)
                B: out <= 1'b1;
                A: out <= 1'b0;
                default: out <= 1'b1;
            endcase
        end
    end

endmodule