module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Gray code state encoding (only 1 bit changes between adjacent states)
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b011;
    localparam D = 3'b010;
    localparam E = 3'b110;
    localparam F = 3'b100;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A; // Handle unused states
        endcase
    end

    // State register and output register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output is registered to break critical paths
            z <= next_state[2]; // MSB indicates z=1 states (E and F)
        end
    end

endmodule