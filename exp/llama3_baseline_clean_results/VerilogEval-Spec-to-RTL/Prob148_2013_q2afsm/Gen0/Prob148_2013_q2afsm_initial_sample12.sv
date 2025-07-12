module TopModule(
    input  clk,
    input  resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Go to state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // Go to state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // Stay in state A, device 2 has lowest priority
            end else begin
                next_state = 2'b00; // Stay in state A if no requests
            end
        end
        2'b01: begin // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in state B if device 0 is still requesting
            end else begin
                next_state = 2'b00; // Go back to state A if device 0 is not requesting
            end
        end
        2'b10: begin // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in state C if device 1 is still requesting
            end else begin
                next_state = 2'b00; // Go back to state A if device 1 is not requesting
            end
        end
        default: begin // State D (not used in this implementation)
            next_state = 2'b00; // Go back to state A
        end
    endcase
end

// Output logic
assign g[0] = (state == 2'b01); // Set g[0] to 1 in state B
assign g[1] = (state == 2'b10); // Set g[1] to 1 in state C
assign g[2] = 1'b0; // g[2] is not used in this implementation

endmodule