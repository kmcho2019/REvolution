module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else case (state)
            A: state <= r[0] ? B : r[1] ? C : r[2] ? D : A;
            B: state <= r[0] ? B : A;
            C: state <= r[1] ? C : A;
            D: state <= r[2] ? D : A;
        endcase
    end

    assign g = {state == D, state == C, state == B};

endmodule