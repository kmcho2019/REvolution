module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 00=A, 01=g0, 10=g1, 11=g2
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00; // Reset to state A
        end else begin
            case (state)
                2'b00: // State A
                    if (r[0]) state <= 2'b01;
                    else if (r[1]) state <= 2'b10;
                    else if (r[2]) state <= 2'b11;
                    else state <= 2'b00;
                2'b01: // g0 state
                    state <= r[0] ? 2'b01 : 2'b00;
                2'b10: // g1 state
                    state <= r[1] ? 2'b10 : 2'b00;
                2'b11: // g2 state
                    state <= r[2] ? 2'b11 : 2'b00;
            endcase
        end
    end

    // Output logic - direct mapping from state
    assign g[0] = (state == 2'b01);
    assign g[1] = (state == 2'b10);
    assign g[2] = (state == 2'b11);

endmodule