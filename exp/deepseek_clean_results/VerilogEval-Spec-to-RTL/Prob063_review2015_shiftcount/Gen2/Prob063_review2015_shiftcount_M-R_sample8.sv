module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Combinational next-state logic
always @(*) begin
    if (shift_ena) begin
        next_q = {q[2:0], data};  // Shift operation
    end
    else if (count_ena) begin
        next_q = q - 1'b1;        // Count operation
    end
    else begin
        next_q = q;               // Hold current value
    end
end

// Sequential state update
always @(posedge clk) begin
    q <= next_q;
end

endmodule