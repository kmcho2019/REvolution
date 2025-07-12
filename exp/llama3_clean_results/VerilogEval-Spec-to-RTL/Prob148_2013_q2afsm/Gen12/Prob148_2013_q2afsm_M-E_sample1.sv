module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot state encoding: A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
reg [3:0] state;
reg [3:0] next_state;

// Next state logic
always @(*)
begin
    case (state)
        4'b0001:  // State A
            next_state = (r[0] ? 4'b0010 : (r[1] ? 4'b0100 : (r[2] ? 4'b1000 : 4'b0001)));
        4'b0010:  // State B
            next_state = r[0] ? 4'b0010 : 4'b0001;
        4'b0100:  // State C
            next_state = r[1] ? 4'b0100 : 4'b0001;
        4'b1000:  // State D
            next_state = r[2] ? 4'b1000 : 4'b0001;
        default:
            next_state = 4'b0001;  // Default to state A
    endcase
end

// Output logic
always @(*)
begin
    case (state)
        4'b0001:  // State A
            g = 3'b000;
        4'b0010:  // State B
            g = 3'b100;
        4'b0100:  // State C
            g = 3'b010;
        4'b1000:  // State D
            g = 3'b001;
        default:
            g = 3'b000;  // Default to no grant
    endcase
end

// State register
always @(posedge clk)
begin
    if (~resetn)
        state <= 4'b0001;  // Reset to state A
    else
        state <= next_state;
end

endmodule