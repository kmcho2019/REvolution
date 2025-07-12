module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // State D
            end else begin
                next_state = 2'b00; // State A
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else begin
                next_state = 2'b00; // State A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else begin
                next_state = 2'b00; // State A
            end
        2'b11: // State D
            // This state is not reachable from the provided state diagram
            next_state = 2'b00; // State A
        default:
            next_state = 2'b00; // State A
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to State A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: // State A
            g = 3'b000;
        2'b01: // State B
            g = 3'b100;
        2'b10: // State C
            g = 3'b010;
        2'b11: // State D
            g = 3'b001;
        default:
            g = 3'b000; // State A
    endcase
end

endmodule