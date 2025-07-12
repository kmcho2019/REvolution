module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg terminal_count;
reg count_enable;

// Pre-compute terminal count one cycle early
always @(posedge clk) begin
    if (reset) begin
        terminal_count <= 1'b0;
    end else begin
        terminal_count <= (q == 4'b1000); // Detect one cycle before terminal
    end
end

// Clock gating control
always @(*) begin
    count_enable = ~terminal_count & ~reset;
end

// Counter logic with clock gating
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (count_enable) begin
        if (q[3] & q[0]) begin  // Check for 9 (1001)
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule