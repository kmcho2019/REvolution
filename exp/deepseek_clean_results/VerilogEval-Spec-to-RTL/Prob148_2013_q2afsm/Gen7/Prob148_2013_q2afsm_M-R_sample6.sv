module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state;

    // Combined state register and next-state logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (1'b1) // Synthesis will recognize this as priority case
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

    // Output logic - continuous assignments
    assign g[0] = state[B];
    assign g[1] = state[C];
    assign g[2] = state[D];

endmodule