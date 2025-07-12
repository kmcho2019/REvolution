module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
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
        S000: begin
            if (~x) next_state = S000;
            else next_state = S001;
        end
        S001: begin
            if (~x) next_state = S001;
            else next_state = S100;
        end
        S010: begin
            if (~x) next_state = S010;
            else next_state = S001;
        end
        S011: begin
            if (~x) next_state = S001;
            else next_state = S010;
        end
        S100: begin
            if (~x) next_state = S011;
            else next_state = S100;
        end
        default: next_state = S000;
    endcase
end

// Output logic
always @ (*) begin
    case (current_state)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0;
    endcase
end

assign Y0 = next_state[0];

endmodule