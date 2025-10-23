module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (current_state)
        2'b00: begin // State A
            if (r[0] == 1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1) begin
                next_state = 2'b10; // State C (based on priority)
            end else begin
                next_state = 2'b00; // State A
            end
        end
        2'b01: begin // State B
            if (r[0] == 1) begin
                next_state = 2'b01; // State B
            end else begin
                next_state = 2'b00; // State A
            end
        end
        2'b10: begin // State C
            if (r[1] == 1) begin
                next_state = 2'b10; // State C
            end else begin
                next_state = 2'b00; // State A
            end
        end
        default: begin
            next_state = 2'b00; // State A (in case of invalid state)
        end
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to State A
    end else begin
        current_state <= next_state;
    end
end

// Outputs
assign g[0] = (current_state == 2'b01); // g0 is high when in State B
assign g[1] = (current_state == 2'b10); // g1 is high when in State C
assign g[2] = 0; // g2 is always low in this implementation

endmodule