module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// State register
reg current_state;
reg next_state;

// Output logic
assign out = current_state;

// Combinational logic for next state
always @(*) begin
    case(current_state)
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
        default: next_state = OFF;
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule