module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Update next state based on current state and input
always @(*)
begin
    case (current_state)
        A: 
            if (~w) 
                next_state = B;
            else 
                next_state = A;
        B: 
            if (~w) 
                next_state = C;
            else 
                next_state = D;
        C: 
            if (~w) 
                next_state = E;
            else 
                next_state = D;
        D: 
            if (~w) 
                next_state = F;
            else 
                next_state = A;
        E: 
            if (w) 
                next_state = E;
            else 
                next_state = D;
        F: 
            if (w) 
                next_state = F;
            else 
                next_state = C;
        default:
            next_state = A;
    endcase
end

// Update current state at positive edge of clock
always @(posedge clk or posedge reset)
begin
    if (reset) 
        current_state <= A;
    else 
        current_state <= next_state;
end

// Assign output z based on current state
always @(*)
begin
    case (current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule