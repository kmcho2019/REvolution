module TopModule(
    input  clk,
    input  d,
    output q
    );

reg q_pos;
reg q_neg;

// Positive edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Select the output based on the current clock edge
always @(posedge clk, negedge clk) begin
    if (clk) begin
        q <= q_pos;
    end else begin
        q <= q_neg;
    end
end

endmodule