module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// Combinational logic for p
assign p = (~q) & a;

// State update logic
always @(posedge clock or negedge clock) begin
    if (negedge clock) begin
        // Asynchronous reset when a is high at falling edge
        if (a) q <= 0;
    end
    else begin
        // Synchronous state update
        q <= p;
    end
end

endmodule