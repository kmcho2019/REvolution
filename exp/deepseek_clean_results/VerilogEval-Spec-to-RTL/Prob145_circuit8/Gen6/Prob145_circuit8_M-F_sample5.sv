module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;  // Stores previous p value

// p is high when a is high during clock high phase
always @(posedge clock) begin
    p <= a & clock;
    p_prev <= p;  // Store previous p value for q
end

// q is set when p was high, cleared asynchronously
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock) begin
        q <= 1'b0;
    end
    else begin
        q <= p_prev;
    end
end

endmodule