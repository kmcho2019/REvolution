module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output q
);

reg q_reg;

// Asynchronous reset logic: immediately reset q_reg when ar is asserted
always @(*) begin
    if (ar) 
        q_reg = 1'b0;
    else
        q_reg = q_reg; // Hold current value when no reset
end

// Synchronous update on positive edge of clock when not resetting
always @(posedge clk) begin
    if (!ar)
        q_reg <= d;
end

assign q = q_reg;

endmodule