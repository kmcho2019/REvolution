module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Declare current state and next state variables
reg [1:0] current_state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                // next_state = D; // Not needed in this case
                next_state = A; // stay in state A if no other request
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0]) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1]) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        default: next_state = A; // Not needed in this case
    endcase
end

// Output signals
assign g[0] = (current_state == B)? 1'b1 : 1'b0;
assign g[1] = (current_state == C)? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since state D is not needed, g[2] is always 0

endmodule