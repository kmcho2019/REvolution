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
                2'b00: begin // State A
                    if (r[0]) state <= 2'b01; // Priority to r0
                    else if (r[1]) state <= 2'b10; // Then r1
                    else if (r[2]) state <= 2'b11; // Finally r2
                end
                2'b01: state <= r[0] ? 2'b01 : 2'b00; // State B
                2'b10: state <= r[1] ? 2'b10 : 2'b00; // State C
                2'b11: state <= 2'b00; // State D (immediate return to A)
            endcase
        end
    end

    // Output logic: g0=1 in B, g1=1 in C, g2=1 in D
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 : 3'b000;

endmodule