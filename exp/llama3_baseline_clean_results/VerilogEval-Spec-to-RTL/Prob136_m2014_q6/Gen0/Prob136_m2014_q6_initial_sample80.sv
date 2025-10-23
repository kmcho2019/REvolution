module TopModule (
    input         clk,
    input         reset,
    input         w,
    output        z
);

// Define states
parameter   A = 3'b000,
            B = 3'b001,
            C = 3'b010,
            D = 3'b011,
            E = 3'b100,
            F = 3'b101;

reg [2:0]   current_state;
reg [2:0]   next_state;

// Define output based on current state
always @(*)
begin
    case (current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = w;
        F: z = w;
        default: z = 0;
    endcase
end

// Define state transition
always @(*)
begin
    case (current_state)
        A: 
        begin
            if (w == 0)
                next_state = B;
            else
                next_state = A;
        end
        B: 
        begin
            if (w == 0)
                next_state = C;
            else
                next_state = D;
        end
        C: 
        begin
            if (w == 0)
                next_state = E;
            else
                next_state = D;
        end
        D: 
        begin
            if (w == 0)
                next_state = F;
            else
                next_state = A;
        end
        E: 
        begin
            if (w == 0)
                next_state = E;
            else
                next_state = D;
        end
        F: 
        begin
            if (w == 0)
                next_state = C;
            else
                next_state = D;
        end
        default: next_state = A;
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

endmodule