module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg p_reg;
reg q_reg;

always @(posedge clock) begin
    p_reg <= a;
end

always @(posedge clock) begin
    if (a == 1) begin
        q_reg <= 1'b1;
    end else begin
        // If a is 0, q stays as it is because of the default
        // However, based on the waveform, when clock goes high and a=0, 
        // q remains high until the next low-to-high clock edge with a=1.
        // Thus, no direct reset condition is provided here; 
        // q's behavior is maintained through the logic outside this block.
    end
end

assign p = p_reg;
assign q = q_reg;

endmodule