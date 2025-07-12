module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    parameter A = 3'b000;  // Idle
    parameter B = 3'b001;  // Grant to device 0
    parameter C = 3'b010;  // Grant to device 1

    reg [2:0] state;

    // Outputs are directly the state bits
    assign g = state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    // Priority order: r[0] > r[1]
                    if (r[0]) state <= B;
                    else if (r[1]) state <= C;
                end
                B: state <= r[0] ? B : A;  // Stay if request continues
                C: state <= r[1] ? C : A;  // Stay if request continues
                default: state <= A;      // Handle any undefined states
            endcase
        end
    end

endmodule