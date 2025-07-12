module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Define the current state and next state signals
reg [1:0] current_state;
reg [1:0] next_state;

// Output logic using continuous assignment
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0;  // Since device 2 doesn't have a corresponding state

// Next state logic
always @(*)
begin
    case (current_state)
        A:
        begin
            if (r[0] == 1'b1)
                next_state = B;
            else if (r[1] == 1'b1)
                next_state = C;
            else if (r[2] == 1'b1)
                next_state = C;  // Go to state C for device 2
            else
                next_state = A;
        end
        B:
        begin
            if (r[0] == 1'b1)
                next_state = B;
            else
                next_state = A;
        end
        C:
        begin
            if (r[1] == 1'b1)
                next_state = C;
            else
                next_state = A;
        end
        default:
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule