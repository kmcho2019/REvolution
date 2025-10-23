module TopModule (
    input  clk,
    input  a,
    output q
);

reg prev_a; // state variable to track the previous value of a
reg q_reg;  // register to hold the value of q

always @(posedge clk) begin
    prev_a <= a; // update the state variable on each clock cycle
    if (prev_a && a) begin // check if a was high in the previous clock cycle and is high in the current clock cycle
        q_reg <= 0; // set q to low if the condition is met
    end else begin
        q_reg <= 1; // otherwise, set q to high
    end
end

assign q = q_reg; // assign the value of q_reg to the output q

endmodule