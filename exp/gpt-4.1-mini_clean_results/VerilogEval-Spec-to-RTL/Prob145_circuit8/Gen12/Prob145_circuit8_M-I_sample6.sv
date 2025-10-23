module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    // Initialize outputs to 0 for simulation consistency
    initial begin
        p = 1'b0;
        q = 1'b0;
    end

    always @(posedge clock) begin
        if (p && q && !a) begin
            // Both set and input low: reset both
            p <= 1'b0;
            q <= 1'b0;
        end
        else if (a) begin
            // Input high: set p to 1, q unchanged
            p <= 1'b1;
            q <= q;
        end
        else begin
            // a=0 and not both p and q=1
            // q set to 1 if p=1 and a=0 at this clock (meaning this case)
            if (p)
                q <= 1'b1;
            else begin
                // p=0: clear q
                q <= 1'b0;
            end
            // p remains or cleared if a=0 and not resetting both
            // p stays as is when a=0 and no reset condition
            if (p && !(p && q && !a)) 
                p <= p;
            else
                p <= p; // redundant but explicit
        end
    end

endmodule