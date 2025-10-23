module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;

// Priority encoder
wire [1:0] priority_code;
assign priority_code = (r[0]? 2'b01 : (r[1]? 2'b10 : (r[2]? 2'b11 : 2'b00)));

// Next state logic and state flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;  // Reset to state A
    end else begin
        case (state)
            2'b00:  // State A
                state <= priority_code;
            2'b01:  // State B
                if (r[0])
                    state <= 2'b01;  // Stay in B if r0 is 1
                else
                    state <= 2'b00;  // Go to A if r0 is 0
            2'b10:  // State C
                if (r[1])
                    state <= 2'b10;  // Stay in C if r1 is 1
                else
                    state <= 2'b00;  // Go to A if r1 is 0
            2'b11:  // State D
                if (r[2])
                    state <= 2'b11;  // Stay in D if r2 is 1
                else
                    state <= 2'b00;  // Go to A if r2 is 0
            default:
                state <= 2'b00;  // Default to state A
        endcase
    end
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule