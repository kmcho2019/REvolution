module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Define state variable
reg [1:0] current_state;
reg [1:0] next_state;

// Define output signals
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0; // Since device 2 has the lowest priority and there's no state that sets g2 to 1

// State table
always @(*)
begin
    case (current_state)
        A:
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                next_state = A; // Since device 2 has the lowest priority
            else
                next_state = A;
        B:
            if (r[0])
                next_state = B;
            else
                next_state = A;
        C:
            if (r[1])
                next_state = C;
            else
                next_state = A;
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