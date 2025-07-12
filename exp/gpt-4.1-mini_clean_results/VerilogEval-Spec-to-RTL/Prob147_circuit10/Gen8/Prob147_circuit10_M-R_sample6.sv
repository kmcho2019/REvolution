module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

always @(*) begin
    // Compute next_state based on current state and inputs
    if (b) begin
        if (a) 
            next_state = ~state;
        else 
            next_state = 1'b1;
    end else begin
        next_state = state;
    end

    // Compute output q based on next_state and inputs
    if (a & b)
        q = ~next_state;
    else
        q = next_state;
end

always @(posedge clk) begin
    state <= next_state;
end

endmodule