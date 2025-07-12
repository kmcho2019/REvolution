module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding
    parameter [1:0] STATE_A = 2'b00;
    parameter [1:0] STATE_B = 2'b01;
    parameter [1:0] STATE_C = 2'b10;
    parameter [1:0] STATE_D = 2'b11;

    reg [1:0] state;

    // Single always block for state transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            case (state)
                STATE_A: begin
                    if (r[0]) state <= STATE_B;
                    else if (r[1]) state <= STATE_C;
                    else if (r[2]) state <= STATE_D;
                end
                STATE_B: state <= r[0] ? STATE_B : STATE_A;
                STATE_C: state <= r[1] ? STATE_C : STATE_A;
                STATE_D: state <= r[2] ? STATE_D : STATE_A;
            endcase
        end
    end

    // Output assignments (combinational)
    assign g[0] = (state == STATE_B);
    assign g[1] = (state == STATE_C);
    assign g[2] = (state == STATE_D);

endmodule