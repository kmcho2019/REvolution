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
parameter D = 2'b11;

// Current state
reg [1:0] current_state;

// Next state
reg [1:0] next_state;

// State flip-flops
always @ (posedge clk or negedge resetn) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @ (*) begin
    case (current_state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                // No transition to state D, so stay in A
                next_state = A;
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
        default: begin
            next_state = A;
        end
    endcase
end

// Output g
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0;

endmodule