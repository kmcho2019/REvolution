module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y;
reg [2:0] next_y;

// Determine the next state based on the current state and input 'x'
always @(*) begin
    case(y)
        3'b000: next_y = (x == 0)? 3'b000 : 3'b001;
        3'b001: next_y = (x == 0)? 3'b001 : 3'b100;
        3'b010: next_y = (x == 0)? 3'b010 : 3'b001;
        3'b011: next_y = (x == 0)? 3'b001 : 3'b010;
        3'b100: next_y = (x == 0)? 3'b011 : 3'b100;
        default: next_y = 3'b000; // Default next state
    endcase
end

// Update the current state on the positive edge of the clock
always @(posedge clk) begin
    if(reset) begin
        y <= 3'b000; // Synchronous active high reset
    end else begin
        y <= next_y;
    end
end

// Determine the output 'z' based on the current state
always @(*) begin
    case(y)
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule