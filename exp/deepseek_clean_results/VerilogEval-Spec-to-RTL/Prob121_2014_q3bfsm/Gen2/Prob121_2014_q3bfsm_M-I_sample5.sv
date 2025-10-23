module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y; // Current state register

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Synchronous reset to state 000
        end else begin
            case (y) // synthesis parallel_case
                3'b000: y <= x ? 3'b001 : 3'b000;
                3'b001: y <= x ? 3'b100 : 3'b001;
                3'b010: y <= x ? 3'b001 : 3'b010;
                3'b011: y <= x ? 3'b010 : 3'b001;
                3'b100: y <= x ? 3'b100 : 3'b011;
            endcase
        end
    end

    // Registered output logic
    always @(posedge clk) begin
        if (reset) begin
            z <= 1'b0;
        end else begin
            z <= y[2] | (y[1] & y[0]); // Equivalent to states 011 or 100
        end
    end

endmodule