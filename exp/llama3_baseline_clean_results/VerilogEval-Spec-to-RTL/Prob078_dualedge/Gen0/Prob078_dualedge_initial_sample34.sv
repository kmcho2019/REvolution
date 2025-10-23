module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg internal_q; // Internal flip-flop to capture d at one edge
reg edge_flag; // Flag to track which edge was last used for capture

always @(posedge clk or negedge clk) begin
    // Detect the edge of the clock to update the flag
    if (clk) begin // Rising edge
        if (!edge_flag) begin // If the last capture wasn't on rising edge
            internal_q <= d; // Capture d
        end
        edge_flag <= 1'b1; // Update the flag
    end else begin // Falling edge
        if (edge_flag) begin // If the last capture wasn't on falling edge
            internal_q <= d; // Capture d
        end
        edge_flag <= 1'b0; // Update the flag
    end
    // Assign the captured value to the output
    q <= internal_q;
end

endmodule