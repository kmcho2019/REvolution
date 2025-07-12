module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

// Combinational logic for output q based on state, a, and b
always @(*) begin
    if (state == 1'b0) begin
        q = b;
    end else begin
        q = ~a;
    end
end

// Sequential logic for state
always @(posedge clk) begin
    // Based on waveforms, state changes when a=0 and b=1 or when a=1 and b=0
    if ((a == 1'b0 && b == 1'b1) || (a == 1'b1 && b == 1'b0)) begin
        state = ~state;
    end
end

endmodule