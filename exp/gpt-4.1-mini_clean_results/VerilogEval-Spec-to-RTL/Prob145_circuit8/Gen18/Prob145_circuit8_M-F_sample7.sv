module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next, q_next;

// Next state logic combinational block
always @* begin
    case ({p, q})
        2'b00: begin
            // From 00:
            // a=1 -> 10
            // a=0 -> 00
            if (a)
                {p_next, q_next} = 2'b10;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b10: begin
            // From 10:
            // a=1 -> 10 (hold)
            // a=0 -> 00
            if (a)
                {p_next, q_next} = 2'b10;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b11: begin
            // From 11:
            // a=1 -> 11 (hold)
            // a=0 -> 10 (q drops to 0)
            if (a)
                {p_next, q_next} = 2'b11;
            else
                {p_next, q_next} = 2'b10;
        end
        2'b01: begin
            // From 01:
            // a=1 -> 11
            // a=0 -> 00
            if (a)
                {p_next, q_next} = 2'b11;
            else
                {p_next, q_next} = 2'b00;
        end
        default: begin
            {p_next, q_next} = 2'b00;
        end
    endcase
end

// State registers updated on posedge clock
always @(posedge clock) begin
    p <= p_next;
    q <= q_next;
end

// Initial unknown states to match waveform
initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule