module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg; // Register to store the state of q
assign q = q_reg; // Output q is assigned the value of q_reg

always @(posedge clock) begin
    if (a) begin
        q_reg <= 1; // Set q to 1 when clock is 1 and a is 1
    end else begin
        // Do nothing, q_reg remains the same
    end
end

assign p = clock & a; // Output p is 1 when clock and a are both 1

endmodule