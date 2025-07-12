module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Hierarchical state encoding:
    // bit[2] = 0: idle state (A)
    // bit[2] = 1: grant state (B/C/D)
    // bits[1:0] encode which device is granted (00=B, 01=C, 10=D)
    localparam [2:0] A = 3'b000,
                     B = 3'b100,
                     C = 3'b101,
                     D = 3'b110;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state[2])
            1'b0: begin // Idle state (A)
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            1'b1: begin // Grant state (B/C/D)
                case (state[1:0])
                    2'b00: next_state = r[0] ? B : A; // B
                    2'b01: next_state = r[1] ? C : A; // C
                    2'b10: next_state = r[2] ? D : A; // D
                    default: next_state = A;
                endcase
            end
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            state <= next_state;
            // Registered outputs
            case (next_state[2:0])
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

endmodule