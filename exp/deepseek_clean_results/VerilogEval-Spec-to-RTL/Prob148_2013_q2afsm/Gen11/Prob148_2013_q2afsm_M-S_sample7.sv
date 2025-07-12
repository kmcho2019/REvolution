module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 3'b001,
               B = 3'b010,
               C = 3'b100;

    reg [2:0] state;

    // State register with synchronous reset and transitions
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else case (state)
            A: begin
                if (r[0]) state <= B;
                else if (r[1]) state <= C;
                else if (r[2]) state <= A;  // D state merged into A
            end
            B: state <= r[0] ? B : A;
            C: state <= r[1] ? C : A;
            default: state <= A;
        endcase
    end

    // Output logic - continuous assignments
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = 1'b0;  // D state removed since it's same as A with g[2]=0

endmodule