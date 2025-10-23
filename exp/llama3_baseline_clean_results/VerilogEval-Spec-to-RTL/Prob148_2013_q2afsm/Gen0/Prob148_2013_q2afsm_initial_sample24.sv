module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [2:0] current_state;
reg [2:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 3'b000; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        3'b000: begin // State A
            if (r[0]) begin
                next_state = 3'b001; // State B
            end else if (r[1]) begin
                next_state = 3'b010; // State C
            end else if (r[2]) begin
                next_state = 3'b000; // State A (but device 2 will receive a grant)
            end else begin
                next_state = 3'b000; // State A
            end
        end
        3'b001: begin // State B
            if (r[0]) begin
                next_state = 3'b001; // State B
            end else begin
                next_state = 3'b000; // State A
            end
        end
        3'b010: begin // State C
            if (r[1]) begin
                next_state = 3'b010; // State C
            end else begin
                next_state = 3'b000; // State A
            end
        end
        default: next_state = 3'b000; // Default to state A
    endcase
end

// FSM outputs
assign g[0] = (current_state == 3'b001); // State B
assign g[1] = (current_state == 3'b010); // State C
assign g[2] = 1'b0; // Device 2 will not receive a grant in this implementation

endmodule