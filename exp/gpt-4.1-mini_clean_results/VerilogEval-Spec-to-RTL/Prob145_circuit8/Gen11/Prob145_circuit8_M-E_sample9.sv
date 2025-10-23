module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        // If both p and q are 1 and a=0, reset both to 0
        if (p && q && !a) begin
            p <= 1'b0;
            q <= 1'b0;
        end
        else begin
            // Update p: set to 1 if a=1, otherwise keep current
            if (a)
                p <= 1'b1;
            else
                p <= p;

            // Update q: set to 1 if p=1 and a=0, else keep current
            if (p && !a)
                q <= 1'b1;
            else
                q <= q;
        end
    end

endmodule