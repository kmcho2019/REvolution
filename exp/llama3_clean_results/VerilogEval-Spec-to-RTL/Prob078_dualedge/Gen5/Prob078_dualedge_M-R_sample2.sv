module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Output when clock is high
reg q_neg;  // Output when clock is low

// Update q_pos and q_neg based on clock edges
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q_pos <= d;
    end else begin
        q_neg <= d;
    end
end

// Select output based on current clock edge
assign q = (clk) ? q_pos : q_neg;

endmodule