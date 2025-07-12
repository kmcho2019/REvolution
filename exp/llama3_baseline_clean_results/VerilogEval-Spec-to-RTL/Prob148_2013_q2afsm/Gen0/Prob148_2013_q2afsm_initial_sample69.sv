module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*)
begin
    case (current_state)
        A:
            if (r[0] == 1) begin
                next_state = B;
            end else if (r[1] == 1) begin
                next_state = C;
            end else if (r[2] == 1) begin
                next_state = C; // since state D is not reachable
            end else begin
                next_state = A;
            end
        B:
            if (r[0] == 1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        C:
            if (r[1] == 1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        default:
            next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk, negedge resetn)
begin
    if (~resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// FSM outputs
assign g[0] = (current_state == B) ? 1'b1 : 1'b0;
assign g[1] = (current_state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Since state D is not reachable

endmodule