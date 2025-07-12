module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

// Next state combinational logic in always block for clarity
always @(*) begin
    if (state == 1'b1) begin
        if (a & b)
            next_state = 1'b0;
        else
            next_state = 1'b1;
    end else begin
        if (~a & b)
            next_state = 1'b1;
        else
            next_state = 1'b0;
    end
end

// Sequential logic: state updates on positive clock edge
always @(posedge clk) begin
    state <= next_state;
end

// Output q equals current state
assign q = state;

// Initial state for deterministic simulation
initial begin
    state = 1'b0;
end

endmodule