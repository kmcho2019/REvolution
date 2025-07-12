module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
enum {A, B} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        B: begin
            if (in == 1'b0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (in == 1'b0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: next_state = B; // Should never reach here
    endcase
end

// Output logic (for Moore machine, output is a function of state only)
assign out = (state == A)? 1'b0 : 1'b1;

endmodule