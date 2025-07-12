module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] state; // 2-bit state: A=00, B=01, C=10, D=11

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00; // Reset to state A
        end else begin
            case (state)
                2'b00: // State A
                    if (r[0]) state <= 2'b01; // B
                    else if (r[1]) state <= 2'b10; // C
                    else if (r[2]) state <= 2'b11; // D
                    else state <= 2'b00; // stay in A
                2'b01: // State B
                    state <= r[0] ? 2'b01 : 2'b00; // stay if r0, else A
                2'b10: // State C
                    state <= r[1] ? 2'b10 : 2'b00; // stay if r1, else A
                2'b11: // State D
                    state <= r[2] ? 2'b11 : 2'b00; // stay if r2, else A
            endcase
        end
    end

    assign g[0] = (state == 2'b01);
    assign g[1] = (state == 2'b10);
    assign g[2] = (state == 2'b11);

endmodule