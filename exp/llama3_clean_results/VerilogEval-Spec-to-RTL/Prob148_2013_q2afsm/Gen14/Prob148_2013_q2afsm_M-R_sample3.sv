module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] state;
reg [1:0] next_state;

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

// Next state logic
always @(*)
begin
    if (state == 2'b00)  // State A
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
    else if (state == 2'b01)  // State B
    begin
        if (r[0])
            next_state = 2'b01;
        else
            next_state = 2'b00;
    end
    else if (state == 2'b10)  // State C
    begin
        if (r[1])
            next_state = 2'b10;
        else
            next_state = 2'b00;
    end
    else if (state == 2'b11)  // State D
    begin
        if (r[2])
            next_state = 2'b11;
        else
            next_state = 2'b00;
    end
    else
        next_state = 2'b00;  // Default to state A
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