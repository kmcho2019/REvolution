module TopModule (
    input clk,
    input d,
    output reg q
);

    reg q_posedge;
    reg q_negedge;
    reg last_clk;

    // Capture 'd' on rising and falling edges separately
    always @(posedge clk) begin
        q_posedge <= d;
    end

    always @(negedge clk) begin
        q_negedge <= d;
    end

    // Detect clock edge and update output synchronously
    always @(posedge clk or posedge last_clk) begin
        last_clk <= clk;

        // Since this always block runs on rising edge and updates last_clk,
        // detect edge by comparing last_clk and clk on next cycles:
        // But mixed edge triggered always not allowed, so do this:
        // Actually, we use a different approach below:
    end

endmodule