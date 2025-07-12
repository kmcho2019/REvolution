module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next, q_next;

// Next state logic: combinational based on current state and input a
always @* begin
    case ({p, q})
        2'b00: begin
            // From 00:
            // If a=1, p=1 q=0; else stay 00
            if (a)
                {p_next, q_next} = 2'b10;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b10: begin
            // From 10:
            // If a=1, stay 10; else go 00
            if (a)
                {p_next, q_next} = 2'b10;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b01: begin
            // From 01:
            // If a=1, go 11; else 00
            if (a)
                {p_next, q_next} = 2'b11;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b11: begin
            // From 11:
            // If a=1, stay 11; else go 01
            if (a)
                {p_next, q_next} = 2'b11;
            else
                {p_next, q_next} = 2'b01;
        end
        default: begin
            {p_next, q_next} = 2'b00;
        end
    endcase
end

// Sequential update of state on posedge clock
always @(posedge clock) begin
    p <= p_next;
    q <= q_next;
end

// Initial unknown states (x) to match waveform at start
initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule