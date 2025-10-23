module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// Generate p output
always @(posedge clock) begin
    p <= a;
end

// Generate q output
always @(negedge clock or posedge (a & ~clock)) begin
    if (a & ~clock) begin
        q <= 1'b0;  // Asynchronous clear
    end else begin
        q <= p;     // Sample p at negative edge
    end
end

endmodule