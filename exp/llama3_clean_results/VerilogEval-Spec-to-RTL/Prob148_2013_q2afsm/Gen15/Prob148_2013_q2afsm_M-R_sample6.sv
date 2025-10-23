module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// One-hot encoding: A = 4'b0001, B = 4'b0010, C = 4'b0100, D = 4'b1000
reg [3:0] state;
reg [3:0] next_state;

// Next state logic and state register
always @(posedge clk)
begin
    if (~resetn)
        state <= 4'b0001;  // Reset to state A
    else
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
        state <= next_state;
    end
end

// Output logic
assign g[0] = state[1];
assign g[1] = state[2];
assign g[2] = state[3];

endmodule