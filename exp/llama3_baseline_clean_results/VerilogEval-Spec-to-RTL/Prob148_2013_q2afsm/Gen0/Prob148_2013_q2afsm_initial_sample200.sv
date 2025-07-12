module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Declare the current and next states
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
                // This case is not specified in the state diagram, but based on the priority,
                // device 2 should only receive a grant if it is the only device making a request.
                // However, this state is not used in the state diagram, so we can ignore it.
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

// Output logic
assign g[0] = (current_state == B);
assign g[1] = (current_state == C);
assign g[2] = 1'b0;

endmodule