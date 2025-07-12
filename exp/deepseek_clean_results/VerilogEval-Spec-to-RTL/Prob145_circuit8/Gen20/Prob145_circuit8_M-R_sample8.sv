module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg a_prev;
reg p_reg;
reg q_reg;

// Detect rising edge of 'a' during clock high
wire a_rise = clock && a && !a_prev;

// p is high for one cycle when rising edge detected
assign p = p_reg;

// q is p delayed by one cycle, cleared when new a rise detected
assign q = q_reg;

always @(posedge clock or negedge clock) begin
    if (posedge clock) begin
        a_prev <= a;
        p_reg <= a_rise;
    end
    else begin // at negative edge
        if (p_reg) begin
            q_reg <= 1'b1;
        end
        else if (a && clock == 1'b0) begin
            q_reg <= 1'b0;
        end
    end
end

initial begin
    a_prev = 1'b0;
    p_reg = 1'b0;
    q_reg = 1'b0;
end

endmodule