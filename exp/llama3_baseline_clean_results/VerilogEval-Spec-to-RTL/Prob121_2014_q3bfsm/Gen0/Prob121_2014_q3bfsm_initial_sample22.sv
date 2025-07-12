module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

// Define the states
reg [2:0] y;

// Initialize the output and state
initial begin
    y = 3'b000;
    z = 1'b0;
end

always @ (posedge clk) begin
    if (reset) begin
        // Synchronous active high reset
        y <= 3'b000;
    end else begin
        case (y)
            3'b000: y <= (x == 1'b0) ? 3'b000 : 3'b001;
            3'b001: y <= (x == 1'b0) ? 3'b001 : 3'b100;
            3'b010: y <= (x == 1'b0) ? 3'b010 : 3'b001;
            3'b011: y <= (x == 1'b0) ? 3'b001 : 3'b010;
            3'b100: y <= (x == 1'b0) ? 3'b011 : 3'b100;
            default: y <= 3'b000; // Default to state 000
        endcase
    end

    // Determine the output 'z' based on the present state
    case (y)
        3'b011, 3'b100: z <= 1'b1;
        default: z <= 1'b0;
    endcase
end

endmodule