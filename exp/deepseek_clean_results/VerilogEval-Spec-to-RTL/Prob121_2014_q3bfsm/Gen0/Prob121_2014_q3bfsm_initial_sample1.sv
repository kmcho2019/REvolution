module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] y; // Current state register

    // State transitions and output logic
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Synchronous reset to state 000
        end else begin
            case (y)
                3'b000: y <= x ? 3'b001 : 3'b000;
                3'b001: y <= x ? 3'b100 : 3'b001;
                3'b010: y <= x ? 3'b001 : 3'b010;
                3'b011: y <= x ? 3'b010 : 3'b001;
                3'b100: y <= x ? 3'b100 : 3'b011;
                default: y <= 3'b000; // Default to state 000 for safety
            endcase
        end
    end

    // Output logic
    assign z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;

endmodule