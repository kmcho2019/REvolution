module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_ff = 0, q_ff = 0;
reg prev_p = 0;

always @(posedge clock) begin
    prev_p <= p_ff;       // Store previous p value
    p_ff <= a;            // p captures current a value
    
    // q is set if p was high in previous cycle
    if (prev_p) begin
        q_ff <= 1;
    end else begin
        q_ff <= 0;
    end
end

assign p = p_ff;
assign q = q_ff;

endmodule