module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    parameter A = 3'b000,
              B = 3'b001,
              C = 3'b010,
              D = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r[0]) state <= B;
                    else if (r[1]) state <= C;
                    else if (r[2]) state <= D;
                end
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                D: state <= A; // D always returns to A next cycle
            endcase
        end
    end

    // Output assignments
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule