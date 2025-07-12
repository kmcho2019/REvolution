module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    localparam A = 2'b00;
    reg [1:0] state, next_state;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always @(*) begin
        case (state)
            A: begin
                if (r[0]) next_state = 2'b01;
                else if (r[1]) next_state = 2'b10;
                else if (r[2]) next_state = 2'b11;
                else next_state = A;
            end
            2'b01: next_state = r[0] ? 2'b01 : A;
            2'b10: next_state = r[1] ? 2'b10 : A;
            2'b11: next_state = r[2] ? 2'b11 : A;
            default: next_state = A;
        endcase
    end

    assign g = {state == 2'b11, state == 2'b10, state == 2'b01};

endmodule