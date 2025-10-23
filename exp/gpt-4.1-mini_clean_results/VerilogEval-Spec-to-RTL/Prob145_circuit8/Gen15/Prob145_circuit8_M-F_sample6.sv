module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    case ({p, q})
        2'b00: begin
            // From 00:
            // if a=1, go to 10 (p=1,q=0)
            // else stay 00 (p=0,q=0)
            if (a)
                {p, q} <= 2'b10;
            else
                {p, q} <= 2'b00;
        end
        2'b10: begin
            // From 10:
            // if a=1, stay 10 (p=1,q=0)
            // else go to 00 (p=0,q=0)
            if (a)
                {p, q} <= 2'b10;
            else
                {p, q} <= 2'b00;
        end
        2'b01: begin
            // From 01:
            // if a=1, go to 11 (p=1,q=1)
            // else go to 00 (p=0,q=0)
            if (a)
                {p, q} <= 2'b11;
            else
                {p, q} <= 2'b00;
        end
        2'b11: begin
            // From 11:
            // if a=1, stay 11 (p=1,q=1)
            // else go to 01 (p=0,q=1)
            if (a)
                {p, q} <= 2'b11;
            else
                {p, q} <= 2'b01;
        end
        default: begin
            {p, q} <= 2'b00;
        end
    endcase
end

initial begin
    p = 0;
    q = 0;
end

endmodule