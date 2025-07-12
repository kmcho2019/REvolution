module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state;
reg [3:0] next_state;

// One-hot encoding scheme
always @(*) begin
    case (state)
        4'b0001: next_state = (r[0]) ? 4'b0010 : (r[1]) ? 4'b0100 : (r[2]) ? 4'b1000 : 4'b0001;
        4'b0010: next_state = (r[0]) ? 4'b0010 : 4'b0001;
        4'b0100: next_state = (r[1]) ? 4'b0100 : 4'b0001;
        4'b1000: next_state = (r[2]) ? 4'b1000 : 4'b0001;
        default: next_state = 4'b0001; // Added default to ensure all cases are handled
    endcase
end

// Power-gating mechanism
reg clk_enable;
always @(*) begin
    case (state)
        4'b0001: clk_enable = 1;
        4'b0010: clk_enable = (r[0]) ? 1 : 0;
        4'b0100: clk_enable = (r[1]) ? 1 : 0;
        4'b1000: clk_enable = (r[2]) ? 1 : 0;
        default: clk_enable = 0; // Added default to ensure all cases are handled
    endcase
end

// Use of non-blocking assignment for state update to reduce potential race conditions
always @(posedge clk) begin
    if (~resetn) state <= 4'b0001;
    else if (clk_enable) state <= next_state;
    else state <= state;
end

// Maintaining continuous assignment for g to minimize area and power
assign g[0] = (state == 4'b0010);
assign g[1] = (state == 4'b0100);
assign g[2] = (state == 4'b1000);

endmodule