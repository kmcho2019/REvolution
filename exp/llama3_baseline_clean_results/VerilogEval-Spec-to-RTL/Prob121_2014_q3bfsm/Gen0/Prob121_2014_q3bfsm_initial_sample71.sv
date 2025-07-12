module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Present state
reg [2:0] next_y; // Next state

// Combinational logic to determine the next state
always @(*) begin
    case (y)
        3'b000: next_y = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_y = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_y = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_y = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_y = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_y = 3'b000;
    endcase
end

// Sequential logic to store and update the present state
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Synchronous active-high reset
    end else begin
        y <= next_y;
    end
end

// Determine the output 'z' based on the present state 'y'
assign z = (y == 3'b011 || y == 3'b100) ? 1'b1 : 1'b0;

endmodule