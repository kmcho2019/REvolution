module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next, q_next;

// Combinational next state logic based on current state and input 'a'
always @* begin
    case ({p, q})
        2'b00: begin
            if (a)
                {p_next, q_next} = 2'b10;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b10: begin
            if (a)
                {p_next, q_next} = 2'b10;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b01: begin
            if (a)
                {p_next, q_next} = 2'b11;
            else
                {p_next, q_next} = 2'b00;
        end
        2'b11: begin
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

// Sequential update on positive clock edge
always @(posedge clock) begin
    p <= p_next;
    q <= q_next;
end

// Initial values to match waveform start with unknown states
initial begin
    p = 1'bx;
    q = 1'bx;
end

endmodule