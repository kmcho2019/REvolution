module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
reg [1:0] current_state, next_state;
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// Asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and output
always @(*) begin
    case (current_state)
        A: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        B: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 0;
        end
        C: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out = 0;
        end
        D: begin
            if (~in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out = 1;
        end
        default: begin
            next_state = A;
            out = 0;
        end
    endcase
end

endmodule