module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare state and next_state variables
reg [1:0] state, next_state;

// State Flip-Flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= A; // reset to state A
    end else begin
        state <= next_state;
    end
end

// State Table
always @(*) begin
    case (state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else if (r[1] == 1'b1) begin
                next_state = C;
            end else if (r[2] == 1'b1) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state = C;
            end else begin
                next_state = A;
            end
        end
        D: begin
            // There is no next state defined for D, but we'll keep it here for completeness
            // In a real implementation, you would handle this case
            next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output Logic
always @(*) begin
    case (state)
        A: g = 3'b000;
        B: g = 3'b100;
        C: g = 3'b010;
        D: g = 3'b001;
        default: g = 3'b000;
    endcase
end

endmodule