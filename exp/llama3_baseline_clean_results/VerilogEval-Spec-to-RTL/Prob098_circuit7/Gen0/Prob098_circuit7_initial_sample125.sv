module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg; // Register to hold the state of q

initial begin // Initialization
    q_reg = 0;
end

always @(posedge clk) begin // Positive edge triggered logic
    if (a == 0 && q_reg == 0) begin // If a is 0 and q is 0, set q to 1
        q_reg <= 1;
    end else if (a == 1) begin // If a is 1, set q to 0
        q_reg <= 0;
    end
end

assign q = q_reg; // Continuous assignment for output q

endmodule