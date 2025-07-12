module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] current_state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        2'b00: begin // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // State D (Unused)
            end else begin
                next_state = 2'b00; // State A
            end
        end
        2'b01: begin // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else begin
                next_state = 2'b00; // State A
            end
        end
        2'b10: begin // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else begin
                next_state = 2'b00; // State A
            end
        end
        2'b11: begin // State D (Unused)
            next_state = 2'b00; // State A
        end
        default: begin
            next_state = 2'b00; // State A
        end
    endcase
end

// Output logic
assign g[0] = (current_state == 2'b01); // State B
assign g[1] = (current_state == 2'b10); // State C
assign g[2] = 1'b0; // Always 0, since state D is unused

endmodule