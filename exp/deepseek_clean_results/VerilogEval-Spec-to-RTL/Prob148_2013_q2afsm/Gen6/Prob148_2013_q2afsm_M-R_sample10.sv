module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (1'b1) // synthesis parallel_case
                state[A]: begin
                    if (r[0])       state <= B;
                    else if (r[1])  state <= C;
                    else if (r[2])  state <= D;
                    else            state <= A;
                end
                state[B]: state <= r[0] ? B : A;
                state[C]: state <= r[1] ? C : A;
                state[D]: state <= r[2] ? D : A;
                default:  state <= A;
            endcase
        end
    end

    // Output assignments
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[B]: g = 3'b001;
            state[C]: g = 3'b010;
            state[D]: g = 3'b100;
            default:  g = 3'b000;
        endcase
    end

endmodule