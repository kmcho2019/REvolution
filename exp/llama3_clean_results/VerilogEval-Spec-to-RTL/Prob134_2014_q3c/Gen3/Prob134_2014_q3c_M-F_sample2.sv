module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the state enumeration
enum logic [2:0] {
    S000 = 3'b000,
    S001 = 3'b001,
    S010 = 3'b010,
    S011 = 3'b011,
    S100 = 3'b100
} state, next;

// Next state logic
always @ (posedge clk) begin
    current_state <= next_state;
end

// Combinational logic for next state
always @ (*) begin
    case (current_state)
        3'b000: begin
            if (~x) next_state = 3'b000;
            else next_state = 3'b001;
        end
        3'b001: begin
            if (~x) next_state = 3'b001;
            else next_state = 3'b100;
        end
        3'b010: begin
            if (~x) next_state = 3'b010;
            else next_state = 3'b001;
        end
        3'b011: begin
            if (~x) next_state = 3'b001;
            else next_state = 3'b010;
        end
        3'b100: begin
            if (~x) next_state = 3'b011;
            else next_state = 3'b100;
        end
        default: next_state = 3'b000;
    endcase
end

// Output logic
always @ (*) begin
    case (current_state)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0;
    endcase
end

always @ (*) begin
    Y0 = next_state[0];
end

endmodule