module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// Define states as enumerated types for clarity
enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} current_state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;  // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A:
            if (r[0]) begin
                next_state = B;
            end else if (r[1]) begin
                next_state = C;
            end else if (r[2]) begin
                next_state = D;
            end else begin
                next_state = A;
            end
        B:
            next_state = r[0] ? B : A;
        C:
            next_state = r[1] ? C : A;
        D:
            next_state = r[2] ? D : A;
        default:
            next_state = A;
    endcase
end

// Assign output signals based on the current state
always @(*) begin
    case (current_state)
        B: g = 3'b100;
        C: g = 3'b010;
        D: g = 3'b001;
        default: g = 3'b000;
    endcase
end

endmodule