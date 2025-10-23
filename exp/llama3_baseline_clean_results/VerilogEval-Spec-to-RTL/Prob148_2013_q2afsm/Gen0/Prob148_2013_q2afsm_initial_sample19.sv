module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0]) begin
                next_state = 2'b01; // State B
            end else if (r[1]) begin
                next_state = 2'b10; // State C
            end else if (r[2]) begin
                // Since state D is not needed, we will not use it
                // next_state = 2'b11; // State D
                // We will keep state A in this case
                next_state = 2'b00;
            end else begin
                next_state = 2'b00; // Stay in state A
            end
        end
        2'b01: begin // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in state B
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        end
        2'b10: begin // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in state C
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        end
        default: next_state = 2'b00; // Go to state A in any other case
    endcase
end

// Output logic
always @(*) begin
    case (state)
        2'b00: begin // State A
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
        2'b01: begin // State B
            g[0] = 1;
            g[1] = 0;
            g[2] = 0;
        end
        2'b10: begin // State C
            g[0] = 0;
            g[1] = 1;
            g[2] = 0;
        end
        default: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
    endcase
end

endmodule