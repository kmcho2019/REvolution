module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding: 
    // 00 - A (no grant)
    // 01 - B (g0 granted)
    // 10 - C (g1 granted)
    // 11 - D (g2 granted)
    reg [1:0] state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 2'b00; // Reset to state A
        end else begin
            case (state)
                2'b00: // State A - no current grant
                    if (r[0]) state <= 2'b01;      // Grant to r0 if requested
                    else if (r[1]) state <= 2'b10;  // Then check r1
                    else if (r[2]) state <= 2'b11;  // Then check r2
                
                2'b01: // State B - g0 granted
                    state <= r[0] ? 2'b01 : 2'b00;  // Maintain if r0 still active
                
                2'b10: // State C - g1 granted
                    state <= r[1] ? 2'b10 : 2'b00;  // Maintain if r1 still active
                
                2'b11: // State D - g2 granted
                    state <= r[2] ? 2'b11 : 2'b00;  // Maintain if r2 still active
            endcase
        end
    end

    // Output assignments
    assign g = (state == 2'b01) ? 3'b001 :  // B state: g0
              (state == 2'b10) ? 3'b010 :  // C state: g1
              (state == 2'b11) ? 3'b100 :   // D state: g2
              3'b000;                       // A state: no grants

endmodule