module TopModule(
    input           clk,
    input           reset,
    input           j,
    input           k,
    output          out
);

// Define states
enum logic [1:0] {OFF, ON} current_state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always_comb begin
    case (current_state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
    endcase
end

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

endmodule