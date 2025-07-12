module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state;
reg [3:0] next_state;

always @(*) begin
    next_state = state;
    if (state[0]) begin
        if (r[0]) next_state = 4'b0001;
        else if (r[1]) next_state = 4'b0010;
        else if (r[2]) next_state = 4'b0100;
        else next_state = 4'b1000;
    end
    else if (state[1]) begin
        if (r[0]) next_state = 4'b0001;
        else if (!r[0] && r[1]) next_state = 4'b0010;
        else next_state = 4'b1000;
    end
    else if (state[2]) begin
        if (r[0]) next_state = 4'b0001;
        else if (!r[0] && r[1]) next_state = 4'b0010;
        else if (!r[0] && !r[1] && r[2]) next_state = 4'b0100;
        else next_state = 4'b1000;
    end
    else if (state[3]) begin
        if (r[0]) next_state = 4'b0001;
        else if (!r[0] && r[1]) next_state = 4'b0010;
        else if (!r[0] && !r[1] && r[2]) next_state = 4'b0100;
        else next_state = 4'b1000;
    end
end

always @(posedge clk) begin
    if (~resetn) state <= 4'b1000;
    else state <= next_state;
end

assign g[0] = state[1];
assign g[1] = state[2];
assign g[2] = state[3];

endmodule