module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_next, q_next;

always @* begin
    // Default next state to current state
    p_next = p;
    q_next = q;

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

always @(posedge clock) begin
    p <= p_next;
    q <= q_next;
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule