module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam [2:0] A = 3'b001,
                     B = 3'b010,
                     C = 3'b100;

    reg [2:0] state;

    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else begin
            case (state)
                A: begin
                    if (r[0]) state <= B;
                    else if (r[1]) state <= C;
                    // Stay in A if only r[2] or no requests
                end
                B: state <= (r[0]) ? B : A;
                C: state <= (r[1]) ? C : A;
                default: state <= A;
            endcase
        end
    end

    // Output logic - g[2] asserted when in A and only r[2]=1
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == A) & ~r[0] & ~r[1] & r[2];

endmodule