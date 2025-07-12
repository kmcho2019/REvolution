module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;  // To track p from previous cycle

// Combinational logic for p (synchronous)
always @(posedge clock) begin
    if (~q) begin
        p <= a;
    end else begin
        p <= 0;
    end
    prev_p <= p;  // Store previous p value
end

// State logic for q
always @(*) begin
    if (a & ~clock) begin
        q = 0;  // Asynchronous reset when a=1 during clock low
    end
    else if (prev_p & ~q) begin
        q = 1;   // Set q after seeing p=1 for full cycle
    end
end

// Sequential part for q (to maintain state)
always @(posedge clock or negedge clock) begin
    if (a & ~clock) begin
        q <= 0;
    end
    else if (prev_p & ~q) begin
        q <= 1;
    end
end

initial begin
    p = 0;
    q = 0;
    prev_p = 0;
end

endmodule