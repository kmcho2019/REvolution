module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} current_state, next_state;

// Output logic
assign out = (current_state == ON)? 1'b1 : 1'b0;

// Next state logic
always_comb begin
    case (current_state)
        OFF: begin
            if (j == 1'b1) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k == 1'b1) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
        default: begin
            next_state = OFF;
        end
    endcase
end

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule