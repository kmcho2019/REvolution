module TopModule(
    input clk,
    input d,
    output reg q
);

reg prev_clk; // Track previous clock value
reg q_pos;    // Value captured on positive edge
reg q_neg;    // Value captured on negative edge

always @(posedge clk or negedge clk) begin
    if (clk != prev_clk) begin // Edge detected
        if (clk) begin // Positive edge
            q_pos <= d;
        end else begin // Negative edge
            q_neg <= d;
        end
    end
    prev_clk <= clk; // Update previous clock value
    q <= clk ? q_pos : q_neg; // Select output based on clock level
end

endmodule