module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot encoded states
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = r[0] ? B : 
                           r[1] ? C : 
                           r[2] ? D : A;
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic - direct mapping from one-hot states
    assign g[0] = (state == B);
    assign g[1] = (state == C);
    assign g[2] = (state == D);

endmodule