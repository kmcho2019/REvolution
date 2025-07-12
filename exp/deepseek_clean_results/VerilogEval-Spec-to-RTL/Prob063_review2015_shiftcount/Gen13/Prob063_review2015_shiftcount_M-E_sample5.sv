module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] next_value;

// Next value logic
assign next_value = shift_ena ? {q[2:0], data} :  // Shift operation
                  count_ena ? q - 1'b1 :        // Count operation
                  q;                            // Hold

always @(posedge clk) begin
    q <= next_value;
end

endmodule