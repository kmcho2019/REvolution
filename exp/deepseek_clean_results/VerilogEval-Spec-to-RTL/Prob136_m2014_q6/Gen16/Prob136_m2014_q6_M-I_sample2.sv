module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoded states (6 states, 6 bits)
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end
        else begin
            case (1'b1) // Priority-encoded case for one-hot
                state[0]: state <= w ? A : B;       // State A
                state[1]: state <= w ? D : C;       // State B
                state[2]: state <= w ? D : E;       // State C
                state[3]: state <= w ? A : F;       // State D
                state[4]: state <= w ? D : E;       // State E
                state[5]: state <= w ? D : C;       // State F
                default:  state <= A;               // Safety net
            endcase
        end
    end

    // Output directly from state bits (E and F have z=1)
    assign z = state[4] | state[5];

endmodule