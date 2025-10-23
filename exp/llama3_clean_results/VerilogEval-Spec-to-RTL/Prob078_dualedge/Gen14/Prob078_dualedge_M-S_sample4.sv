module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous state of the clock
reg q_temp;    // Temporary output

// Initialize q and prev_clk
initial begin
    q = 0;
    prev_clk = 0;
end

// Update q_temp based on the input d and the clock edge
always @(posedge clk or negedge clk) begin
    if (d) begin
        if ((clk == 1 && prev_clk == 0) || (clk == 0 && prev_clk == 1)) begin
            q_temp <= ~q_temp;
        end
    end
    prev_clk <= clk;
end

// Assign the final output q
assign q = (d)? q_temp : q;

endmodule