module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

// Combinational logic using multiplexers
reg mux_out;
always @(*) begin
    // Select between Q and ~Q based on J and K
    if (j && ~k) begin
        mux_out = 1'b1;
    end else if (~j && k) begin
        mux_out = 1'b0;
    end else if (j && k) begin
        mux_out = ~Q;
    end else begin
        mux_out = Q;
    end
end

// Sequential logic to update the state at the positive clock edge
always @(posedge clk) begin
    Q <= mux_out;
end

endmodule