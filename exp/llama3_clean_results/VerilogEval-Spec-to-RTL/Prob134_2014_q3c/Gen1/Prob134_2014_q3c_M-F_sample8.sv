module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg z; // Declare z as a reg

always @ (posedge clk) begin
    current_state <= next_state;
end

always @ (*) begin
    case (current_state)
        3'b000: 
            if (~x) next_state = 3'b000;
            else next_state = 3'b001;
        3'b001: 
            if (~x) next_state = 3'b001;
            else next_state = 3'b100;
        3'b010: 
            if (~x) next_state = 3'b010;
            else next_state = 3'b001;
        3'b011: 
            if (~x) next_state = 3'b001;
            else next_state = 3'b010;
        3'b100: 
            if (~x) next_state = 3'b011;
            else next_state = 3'b100;
        default: next_state = 3'b000; // default state
    endcase
end

always @ (*) begin
    case (current_state)
        3'b000, 3'b001, 3'b010: z = 0;
        3'b011, 3'b100: z = 1;
        default: z = 0; // default output
    endcase
end

assign Y0 = current_state[0]; // Use current_state for Y0

initial begin
    current_state = 3'b000; // Initialize current_state to a known value
    next_state = 3'b000; // Initialize next_state to a known value
end

endmodule