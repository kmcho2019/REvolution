module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// State transitions and output logic
always @* begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
            out = 0;
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
            out = 1;
        end
    endcase
end

endmodule