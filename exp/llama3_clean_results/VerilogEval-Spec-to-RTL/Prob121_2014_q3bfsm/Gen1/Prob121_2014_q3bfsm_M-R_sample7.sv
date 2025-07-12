module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg next_z; // Next output

// Next state logic
always @(y or x) begin
    case (y)
        3'b000: next_y = (x == 0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000; // Don't care states default to 000
    endcase
end

// Output logic
always @(y) begin
    case (y)
        3'b000, 3'b001, 3'b010: next_z = 0;
        3'b011, 3'b100: next_z = 1;
        default: next_z = 0; // Don't care states default output to 0
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to state 000
        y <= 3'b000;
        z <= 0;
    end else begin
        y <= next_y;
        z <= next_z;
    end
end

endmodule