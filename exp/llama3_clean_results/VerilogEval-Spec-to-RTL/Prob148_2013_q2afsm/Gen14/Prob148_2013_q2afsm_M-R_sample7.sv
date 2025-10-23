module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Output logic within an always block
always @(*)
begin
    case (state)
        2'b00:  // State A
            begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
        2'b01:  // State B
            begin
                g[0] = 1'b1;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
        2'b10:  // State C
            begin
                g[0] = 1'b0;
                g[1] = 1'b1;
                g[2] = 1'b0;
            end
        2'b11:  // State D
            begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b1;
            end
        default:
            begin
                g[0] = 1'b0;
                g[1] = 1'b0;
                g[2] = 1'b0;
            end
    endcase
end

// Next state logic
always @(*)
begin
    if (r[0])
        next_state = 2'b01;
    else if (r[1])
        next_state = 2'b10;
    else if (r[2])
        next_state = 2'b11;
    else
        next_state = 2'b00;
end

// State register
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;  // Reset to state A
    else
        state <= next_state;
end

endmodule