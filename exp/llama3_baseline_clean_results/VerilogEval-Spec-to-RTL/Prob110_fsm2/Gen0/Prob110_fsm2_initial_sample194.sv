module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [1:0] state; // Using 2 bits for two states, but in reality, we only need 1 bit
reg [1:0] next_state;

// Define states
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Output logic
always @(state) begin
    case(state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
        default: out <= 1'b0; // Should not happen
    endcase
end

// Next state logic
always @(j, k, state) begin
    case(state)
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
        default: next_state = OFF; // Should not happen
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule