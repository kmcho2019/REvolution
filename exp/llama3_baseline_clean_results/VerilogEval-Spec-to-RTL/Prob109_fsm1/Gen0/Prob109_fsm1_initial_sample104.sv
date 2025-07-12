module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // 1 bit to represent states A and B
reg [0:0] next_state;

// Combinational logic for next state and output
always @(*) begin
    case (current_state)
        1'b0: begin // State A
            if (~in) begin
                next_state = 1'b1; // A (0) --0--> B
                out = 1'b0;
            end else begin
                next_state = 1'b0; // A (0) --1--> A
                out = 1'b0;
            end
        end
        1'b1: begin // State B
            if (~in) begin
                next_state = 1'b0; // B (1) --0--> A
                out = 1'b1;
            end else begin
                next_state = 1'b1; // B (1) --1--> B
                out = 1'b1;
            end
        end
        default: begin
            next_state = 1'b0; // Default to state A if unknown state
            out = 1'b0;
        end
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

endmodule