module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Initialize state
initial begin
    current_state = 3'b000;
end

// Sequential logic and combinational logic for next state and output
always @ (posedge clk) begin
    current_state <= next_state;
end

always @ (*) begin
    case (y)
        3'b000: next_state = x? 3'b001 : 3'b000;
        3'b001: next_state = x? 3'b100 : 3'b001;
        3'b010: next_state = x? 3'b001 : 3'b010;
        3'b011: next_state = x? 3'b010 : 3'b001;
        3'b100: next_state = x? 3'b100 : 3'b011;
        default: next_state = 3'b000;
    endcase
    
    z = (y == 3'b011 || y == 3'b100);
end

assign Y0 = next_state[0];

endmodule