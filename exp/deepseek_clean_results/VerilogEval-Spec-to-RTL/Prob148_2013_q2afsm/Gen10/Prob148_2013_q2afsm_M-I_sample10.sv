module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;  // Grant to r0
    localparam C = 4'b0100;  // Grant to r1
    localparam D = 4'b1000;  // Grant to r2
    
    reg [3:0] state, next_state;

    // Combined state register and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end
        else begin
            state <= next_state;
            case (next_state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

    // Next state logic with priority
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

endmodule