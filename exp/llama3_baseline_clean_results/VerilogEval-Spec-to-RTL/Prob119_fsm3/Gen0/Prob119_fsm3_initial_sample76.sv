module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

// Enumerating states
typedef enum logic [1:0] {A, B, C, D} state_t;

// Current and next state
reg state_t current_state;
reg state_t next_state;

// Sequential logic (reset is included)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state
always @(*) begin
    case (current_state)
        A: begin
            if (~in) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            if (~in) begin
                next_state <= C;
            end else begin
                next_state <= B;
            end
        end
        C: begin
            if (~in) begin
                next_state <= A;
            end else begin
                next_state <= D;
            end
        end
        D: begin
            if (~in) begin
                next_state <= C;
            end else begin
                next_state <= B;
            end
        end
    endcase
end

// Combinational logic for output
always @(*) begin
    case (current_state)
        A, B, C: begin
            out <= 1'b0;
        end
        D: begin
            out <= 1'b1;
        end
    endcase
end

endmodule