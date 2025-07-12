module TopModule (
    input clk,
    input d,
    output q
);

    // Storage elements for both clock edges
    reg q_pos;  // Positive edge triggered
    reg q_neg;  // Negative edge triggered

    // Capture data on positive clock edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture data on negative clock edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Select output based on current clock phase
    // Uses clock as mux select for optimal implementation
    assign q = clk ? q_pos : q_neg;

endmodule