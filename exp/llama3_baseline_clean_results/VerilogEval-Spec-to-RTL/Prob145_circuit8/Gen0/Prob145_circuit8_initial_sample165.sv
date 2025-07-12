module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg q_reg; // Register to store the state of q

assign p = clock && a; // p is 1 when a and clock are both 1

always @(posedge clock or negedge clock) begin
    if (~clock && ~a) begin // If clock is 0 and a is 0, reset q
        q_reg <= 0;
    end else if (clock && a) begin // If clock is 1 and a is 1, set q
        q_reg <= 1;
    end
end

assign q = q_reg; // Assign the stored state of q to the output q

endmodule