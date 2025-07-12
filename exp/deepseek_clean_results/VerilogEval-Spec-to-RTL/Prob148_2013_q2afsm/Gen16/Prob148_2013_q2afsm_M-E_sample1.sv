module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001;  // Idle state
    localparam B = 4'b0010;  // Grant to device 0
    localparam C = 4'b0100;  // Grant to device 1
    localparam D = 4'b1000;  // Grant to device 2

    reg [3:0] state;
    wire any_request = |r;  // First-stage quick detection

    // State transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (1'b1)  // Synthesis-friendly case statement
                state[A]: begin
                    if (any_request) begin
                        if (r[0]) state <= B;
                        else if (r[1]) state <= C;
                        else state <= D;
                    end
                end
                state[B]: state <= r[0] ? B : A;
                state[C]: state <= r[1] ? C : A;
                state[D]: state <= r[2] ? D : A;
                default: state <= A;
            endcase
        end
    end

    // Output assignments - direct from state bits
    assign g = {state[D], state[C], state[B]};

endmodule