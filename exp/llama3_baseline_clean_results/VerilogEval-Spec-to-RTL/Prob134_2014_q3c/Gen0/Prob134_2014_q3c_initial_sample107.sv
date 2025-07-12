module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    case (current_state)
        3'b000: next_state = x ? 3'b001 : 3'b000;
        3'b001: next_state = x ? 3'b100 : 3'b001;
        3'b010: next_state = x ? 3'b001 : 3'b010;
        3'b011: next_state = x ? 3'b010 : 3'b001;
        3'b100: next_state = x ? 3'b100 : 3'b011;
        default: next_state = 3'b000; // Default state
    endcase
    
    case (current_state)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
    
    Y0 = next_state[0];
end

assign y = current_state; // To match the module interface requirement

endmodule