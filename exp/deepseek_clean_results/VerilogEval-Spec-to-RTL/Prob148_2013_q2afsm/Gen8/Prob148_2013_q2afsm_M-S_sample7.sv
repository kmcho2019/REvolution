module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] state; // Binary encoding: A=00, B=01, C=10, D=11

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00; // Reset to state A
        end else begin
            case (state)
                2'b00: // State A
                    if (r[0]) state <= 2'b01; // B
                    else if (r[1]) state <= 2'b10; // C
                    else if (r[2]) state <= 2'b11; // D
                2'b01: // State B
                    if (!r[0]) state <= 2'b00; // A
                2'b10: // State C
                    if (!r[1]) state <= 2'b00; // A
                2'b11: // State D
                    if (!r[2]) state <= 2'b00; // A
            endcase
        end
    end

    assign g[0] = (state == 2'b01);
    assign g[1] = (state == 2'b10);
    assign g[2] = (state == 2'b11);

endmodule