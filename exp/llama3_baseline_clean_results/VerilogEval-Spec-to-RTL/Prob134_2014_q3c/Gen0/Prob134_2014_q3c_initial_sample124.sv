module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output z
);

reg [2:0] curr_state;
reg [2:0] next_state;

// Initialize current state to 0
initial
    curr_state = 3'b000;

// Output and next state logic
always @(*)
begin
    case (curr_state)
        3'b000: 
            if (!x) 
                next_state = 3'b000;
            else 
                next_state = 3'b001;
            z = 1'b0;
        3'b001: 
            if (!x) 
                next_state = 3'b001;
            else 
                next_state = 3'b100;
            z = 1'b0;
        3'b010: 
            if (!x) 
                next_state = 3'b010;
            else 
                next_state = 3'b001;
            z = 1'b0;
        3'b011: 
            if (!x) 
                next_state = 3'b001;
            else 
                next_state = 3'b010;
            z = 1'b1;
        3'b100: 
            if (!x) 
                next_state = 3'b011;
            else 
                next_state = 3'b100;
            z = 1'b1;
        default: 
            next_state = 3'b000;
            z = 1'b0;
    endcase
end

// Update current state at every clock cycle
always @(posedge clk)
    curr_state <= next_state;

// Output Y0
assign Y0 = next_state[0];

// Assign y to current state
assign y = curr_state;

endmodule