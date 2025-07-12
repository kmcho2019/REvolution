module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// Binary state encoding: 2 bits suffice for 4 states
localparam [1:0]
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11;

reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case(state)
        A: begin
            if (r[0])         next_state = B;            // highest priority to device 0
            else if (r[1])    next_state = C;            // then device 1
            else if (r[2])    next_state = D;            // then device 2
            else              next_state = A;            // no requests remain in A
        end
        B: begin
            if (r[0])         next_state = B;            // device 0 keeps grant as long as r[0]=1
            else              next_state = A;            // no request from device 0, return to A
        end
        C: begin
            if (r[1])         next_state = C;            // device 1 keeps grant as long as r[1]=1
            else              next_state = A;            // no request from device 1, return to A
        end
        D: begin
            if (r[2])         next_state = D;            // device 2 keeps grant as long as r[2]=1
            else              next_state = A;            // no request from device 2, return to A
        end
        default: next_state = A;
    endcase
end

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Output logic: grant signals based on current state
assign g = (state == B) ? 3'b001 :
           (state == C) ? 3'b010 :
           (state == D) ? 3'b100 :
                          3'b000;

endmodule