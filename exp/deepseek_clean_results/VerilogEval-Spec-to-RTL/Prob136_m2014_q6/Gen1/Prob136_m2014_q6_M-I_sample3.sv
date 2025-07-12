module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Gray code state encoding (only one bit changes between adjacent states)
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b011;
    localparam D = 3'b010;
    localparam E = 3'b110;
    localparam F = 3'b111;

    reg [2:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // State register and output register
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // Registered output to prevent glitches
            z <= (next_state == E) | (next_state == F);
        end
    end

endmodule