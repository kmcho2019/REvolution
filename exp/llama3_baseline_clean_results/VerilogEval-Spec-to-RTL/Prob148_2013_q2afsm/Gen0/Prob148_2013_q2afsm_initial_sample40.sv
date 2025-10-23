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
parameter D = 2'b11;

// Declare state variable
reg [1:0] state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (state)
        A: begin
            if (!r[0] && !r[1] && !r[2])
                next_state = A;
            else if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else
                next_state = D;
        end
        B: begin
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // D is not reachable according to the given state diagram
            // So, we will assign next_state to A by default
            next_state = A;
        end
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since state D is not reachable, g[2] is always 0

endmodule