module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011
reg [2:0] state, next_state;

// State table
always @(*) begin
    case (state)
        3'b000: // State A
            if (r[0]) begin
                next_state = 3'b001; // State B
            end else if (r[1]) begin
                next_state = 3'b010; // State C
            end else if (r[2]) begin
                next_state = 3'b011; // State D
            end else begin
                next_state = 3'b000; // State A
            end
        3'b001: // State B
            next_state = r[0]? 3'b001 : 3'b000;
        3'b010: // State C
            next_state = r[1]? 3'b010 : 3'b000;
        3'b011: // State D
            next_state = r[2]? 3'b011 : 3'b000;
        default:
            next_state = 3'b000;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Outputs
assign g[0] = (state == 3'b001); // State B grants device 0
assign g[1] = (state == 3'b010); // State C grants device 1
assign g[2] = (state == 3'b011); // State D grants device 2

endmodule