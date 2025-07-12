module TopModule(
    input clk,
    input d,
    output q
);

reg clk_int; // Internal clock, twice as fast as clk
reg clk_enable; // Enable signal for the flip-flop
reg q_reg; // Flip-flop output register

// Generate internal clock that is twice as fast as clk
always @(posedge clk or negedge clk) begin
    if (clk) begin // On positive edge
        clk_int <= 1'b1;
    end else begin // On negative edge
        clk_int <= 1'b0;
    end
end

// Generate clock enable signal
always @(posedge clk_int or negedge clk_int) begin
    if (clk_int) begin // On positive edge of internal clock
        clk_enable <= 1'b1;
    end else begin // On negative edge of internal clock
        clk_enable <= 1'b0;
    end
end

// Dual-edge triggered flip-flop implementation
always @(posedge clk_int) begin
    if (clk_enable) begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule