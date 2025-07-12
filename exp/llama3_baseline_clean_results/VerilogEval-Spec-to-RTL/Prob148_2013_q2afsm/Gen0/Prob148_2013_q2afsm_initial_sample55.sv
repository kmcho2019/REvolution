module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// State Flip-Flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next State Logic
always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0]) begin
                next_state <= 2'b01; // State B
            end else if (r[1]) begin
                next_state <= 2'b10; // State C
            end else if (r[2]) begin
                next_state <= 2'b11; // State D
            end else begin
                next_state <= 2'b00; // State A
            end
        end
        2'b01: begin // State B
            if (r[0]) begin
                next_state <= 2'b01; // State B
            end else begin
                next_state <= 2'b00; // State A
            end
        end
        2'b10: begin // State C
            if (r[1]) begin
                next_state <= 2'b10; // State C
            end else begin
                next_state <= 2'b00; // State A
            end
        end
        2'b11: begin // State D
            // This state is not used in the given state diagram
            // But we can add next state logic if needed
            next_state <= 2'b00; // State A
        end
        default: begin
            next_state <= 2'b00; // State A
        end
    endcase
end

// Output Logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // g[2] is not used in the given state diagram

endmodule