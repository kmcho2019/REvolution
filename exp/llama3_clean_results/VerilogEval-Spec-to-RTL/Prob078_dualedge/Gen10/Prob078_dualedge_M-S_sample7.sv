module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk;  // Previous clock value
reg q_int;     // Internal flip-flop output

// Detect clock edge and capture data
always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin  // Clock edge detected
        q_int <= d;             // Capture data
    end
    prev_clk <= clk;            // Update previous clock value
end

// Direct output assignment
assign q = q_int;

endmodule