module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

localparam A=2'd0, B=2'd1, C=2'd2, D=2'd3;

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

always @(*) begin
    case(state)
        A: begin
            if (r[0]) begin
                next_state = B;
                g = 3'b001;
            end else if (r[1]) begin
                next_state = C;
                g = 3'b010;
            end else if (r[2]) begin
                next_state = D;
                g = 3'b100;
            end else begin
                next_state = A;
                g = 3'b000;
            end
        end
        B: begin
            g = 3'b001;
            next_state = r[0] ? B : A;
        end
        C: begin
            g = 3'b010;
            next_state = r[1] ? C : A;
        end
        D: begin
            g = 3'b100;
            next_state = r[2] ? D : A;
        end
        default: begin
            next_state = A;
            g = 3'b000;
        end
    endcase
end

endmodule