module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else begin
            case (state)
                A: if (r[0]) state <= B;
                   else if (r[1]) state <= C;
                   else if (r[2]) state <= D;
                   else state <= A;
                B: state <= r[0] ? B : A;
                C: state <= r[1] ? C : A;
                D: state <= r[2] ? D : A;
                default: state <= A;
            endcase
        end
    end

    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 : 3'b000;

endmodule