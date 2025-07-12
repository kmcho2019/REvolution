module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: A=00, B=01, C=10, D=11
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00; // Reset to state A
        end else begin
            case (state)
                2'b00: begin // State A
                    if (r[0]) state <= 2'b01;      // Priority to r0
                    else if (r[1]) state <= 2'b10; // Then r1
                    else if (r[2]) state <= 2'b11; // Then r2
                end
                2'b01: begin // State B (g0=1)
                    if (!r[0]) state <= 2'b00; // Return to A if r0 drops
                end
                2'b10: begin // State C (g1=1)
                    if (!r[1]) state <= 2'b00; // Return to A if r1 drops
                end
                2'b11: begin // State D (g2=1)
                    if (!r[2]) state <= 2'b00; // Return to A if r2 drops
                end
            endcase
        end
    end

    // Output assignments based on current state
    assign g = (state == 2'b01) ? 3'b001 : // B: g0
               (state == 2'b10) ? 3'b010 : // C: g1
               (state == 2'b11) ? 3'b100 :  // D: g2
               3'b000;                      // A: no grants

endmodule