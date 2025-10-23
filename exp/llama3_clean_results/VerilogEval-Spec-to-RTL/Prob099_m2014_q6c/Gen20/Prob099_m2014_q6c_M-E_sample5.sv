module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define the next-state signals Y2 and Y4
output Y2;
output Y4;

// Internal signals for current state and next state
reg [5:0] curr_state;
reg [5:0] next_state;

// Assign the current state
always @(*) begin
    curr_state = y;
end

// Determine the next state based on the current state and input condition
always @(*) begin
    case (curr_state)
        6'b000001: // State A
            if (~w) begin
                next_state = 6'b000010; // State B
            end else begin
                next_state = 6'b000001; // State A
            end
        6'b000010: // State B
            if (~w) begin
                next_state = 6'b000100; // State C
            end else begin
                next_state = 6'b001000; // State D
            end
        6'b000100: // State C
            if (~w) begin
                next_state = 6'b010000; // State E
            end else begin
                next_state = 6'b001000; // State D
            end
        6'b001000: // State D
            if (~w) begin
                next_state = 6'b100000; // State F
            end else begin
                next_state = 6'b000001; // State A
            end
        6'b010000: // State E
            if (w) begin
                next_state = 6'b010000; // State E
            end else begin
                next_state = 6'b010000; // State E
            end
        6'b100000: // State F
            if (w) begin
                next_state = 6'b000100; // State C
            end else begin
                next_state = 6'b001000; // State D
            end
        default: begin
            next_state = 6'b000001; // State A (reset)
        end
    endcase
end

// Assign the next-state signals Y1, Y2, Y3, and Y4
assign Y1 = next_state[1];
assign Y2 = next_state[2];
assign Y3 = next_state[3];
assign Y4 = next_state[4];

endmodule