module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] state;  // state[0] = p, state[1] = q

// Continuous assignments for outputs
assign p = state[0];
assign q = state[1];

always @(posedge clock) begin
    if (a) begin
        // Reset condition: when a is 1, q goes to 0
        state <= {a & ~state[1], 1'b0};
    end
    else begin
        // Normal operation:
        // p follows a when q is 0
        // q becomes previous p value
        state <= {a & ~state[1], state[0]};
    end
end

initial begin
    state = 2'b00;  // Initialize both p and q to 0
end

endmodule