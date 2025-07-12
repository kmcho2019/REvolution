module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg z_reg; // Output register

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin
        y <= 3'b000; // Synchronous reset
    end else begin
        y <= next_y;
    end
    z_reg <= (y == 3'b011 || y == 3'b100); // Output logic
end

// Combinational logic for next state and output
always @(*) begin
    case(y)
        3'b000: next_y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000; // Default next state
    endcase
end

assign z = z_reg; // Assign output

endmodule