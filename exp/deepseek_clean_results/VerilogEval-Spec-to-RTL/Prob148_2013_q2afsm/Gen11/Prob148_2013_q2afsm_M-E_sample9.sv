module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding:
    // [2:0] = {g2_active, g1_active, g0_active}
    // g2_active also serves as rotation flag
    reg [2:0] state;

    // Rotated priority selection
    wire [2:0] priority_r = state[2] ? {r[0], r[2], r[1]} :  // Rotated priority order
                           {r[0], r[1], r[2]};              // Standard priority order

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 3'b000;  // Reset to state A
        end else begin
            case (state)
                3'b000: begin // State A - no grants
                    if (priority_r[0]) state <= 3'b001;  // Grant to device 0
                    else if (priority_r[1]) state <= 3'b010;  // Grant to device 1
                    else if (priority_r[2]) state <= 3'b100;  // Grant to device 2
                end
                
                3'b001: begin // Device 0 granted
                    if (!r[0]) state <= 3'b000;  // Release if request drops
                end
                
                3'b010: begin // Device 1 granted
                    if (!r[1]) state <= {~state[2], 1'b0, 1'b0}; // Release and toggle rotation
                end
                
                3'b100: begin // Device 2 granted
                    if (!r[2]) state <= 3'b000;  // Release
                end
                
                default: state <= 3'b000;
            endcase
        end
    end

    // Output assignments
    assign g = state;

endmodule