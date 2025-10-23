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
parameter D = 2'b11;

// Declare the state flip-flop
reg [1:0] state;
reg [1:0] next_state;

// Determine the output signals g based on the current state
assign g[0] = (state == B) ? 1'b1 : 1'b0;
assign g[1] = (state == C) ? 1'b1 : 1'b0;
assign g[2] = 1'b0; // g2 is not used in the state diagram

// State table
always @(*) begin
    case (state)
        A: begin
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
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
        D: begin
            next_state = A;
        end
        default: begin
            next_state = A;
        end
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule