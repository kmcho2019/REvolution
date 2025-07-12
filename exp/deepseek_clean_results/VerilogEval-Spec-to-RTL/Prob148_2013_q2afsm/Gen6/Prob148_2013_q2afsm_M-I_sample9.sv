module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Gray code state encoding (A:00, B:01, C:11, D:10)
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b11,
                     D = 2'b10;

    reg [1:0] state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end
        else begin
            state <= next_state;
            // Registered outputs
            case (next_state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

    // Next state logic with flattened priority
    always @(*) begin
        case (state)
            A: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

endmodule