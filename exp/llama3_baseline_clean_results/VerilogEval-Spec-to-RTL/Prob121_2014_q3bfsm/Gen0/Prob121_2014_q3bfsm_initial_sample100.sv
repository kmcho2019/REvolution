module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg z_out; // Output z

// Determine next state
always @(*) begin
    case (y)
        3'b000: next_y = x? 3'b001 : 3'b000;
        3'b001: next_y = x? 3'b100 : 3'b001;
        3'b010: next_y = x? 3'b001 : 3'b010;
        3'b011: next_y = x? 3'b010 : 3'b001;
        3'b100: next_y = x? 3'b100 : 3'b011;
        default: next_y = 3'b000; // Default to state 000 if not specified
    endcase
end

// Update current state and output z
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous reset
        z_out <= 0;
    end else begin
        y <= next_y;
        case (y)
            3'b000, 3'b001, 3'b010: z_out <= 0;
            3'b011, 3'b100: z_out <= 1;
            default: z_out <= 0; // Default output to 0 if not specified
        endcase
    end
end

assign z = z_out;

endmodule