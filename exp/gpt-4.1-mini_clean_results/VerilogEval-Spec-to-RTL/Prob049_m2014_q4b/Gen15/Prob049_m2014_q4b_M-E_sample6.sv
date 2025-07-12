module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

reg q_next;

// Combinational logic to determine next state
always @(*) begin
    if (ar) begin
        q_next = 1'b0;  // Asynchronous reset forces next state to 0
    end else begin
        q_next = d;     // Otherwise next state follows input d
    end
end

// Sequential logic updates state at clock edge
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;      // Asynchronous reset active
    end else begin
        q <= q_next;    // Update state with next value
    end
end

endmodule