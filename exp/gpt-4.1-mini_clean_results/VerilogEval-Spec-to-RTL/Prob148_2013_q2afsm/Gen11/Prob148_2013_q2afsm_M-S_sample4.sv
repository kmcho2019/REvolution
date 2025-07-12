module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

localparam A = 2'd0, B = 2'd1, C = 2'd2;

reg [1:0] state, next_state;

always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        A: begin
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                next_state = C;
            else
                next_state = A;
        end
        B: next_state = (r[0]) ? B : A;
        C: begin
            if (r[1])
                next_state = C;
            else if (r[2])
                next_state = C;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

always @(*) begin
    case (state)
        B: g = 3'b001;        // grant device 0
        C: begin
            if (r[1])
                g = 3'b010;  // grant device 1
            else if (r[2])
                g = 3'b100;  // grant device 2
            else
                g = 3'b000;
        end
        default: g = 3'b000;
    endcase
end

endmodule