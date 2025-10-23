module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(*) begin
    case(current_state)
        3'b000: next_state = (x == 1'b0) ? 3'b000 : 3'b001;
        3'b001: next_state = (x == 1'b0) ? 3'b001 : 3'b100;
        3'b010: next_state = (x == 1'b0) ? 3'b010 : 3'b001;
        3'b011: next_state = (x == 1'b0) ? 3'b001 : 3'b010;
        3'b100: next_state = (x == 1'b0) ? 3'b011 : 3'b100;
        default: next_state = 3'b000; // Default to state 000 for all other cases
    endcase

    case({current_state, x})
        4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b0111: z = 1'b0;
        4'b1000, 4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: z = (current_state == 3'b011 || current_state == 3'b100) ? 1'b1 : 1'b0;
        default: z = 1'b0;
    endcase
end

always @(posedge clk) begin
    current_state <= next_state;
end

assign Y0 = next_state[0];

initial begin
    current_state <= 3'b000; // Initialize state to 000
end

endmodule