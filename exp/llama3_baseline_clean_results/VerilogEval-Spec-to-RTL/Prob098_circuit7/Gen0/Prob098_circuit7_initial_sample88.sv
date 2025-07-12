module TopModule(
    input clk,
    input a,
    output q
);

reg q_reg = 1'b1; // Initialize q_reg to 1

always @(posedge clk) begin
    if (a) begin // If a is high at the positive edge of the clock
        q_reg <= 1'b0; // Set q_reg to 0 at the next clock edge
    end else begin // If a is low
        if (q_reg == 1'b0) begin // And q_reg is already 0
            q_reg <= 1'b0; // Keep q_reg as 0
        end else begin // If q_reg is 1 (initial state or after reset)
            q_reg <= 1'b1; // Keep q_reg as 1
        end
    end
end

assign q = q_reg; // Assign q_reg to the output q

endmodule