module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attribute async_reg of Q is true;
reg [63:0] Q_next;
reg clk_en;

always @(*) begin
    // Gray-code variant with reduced transitions
    if (!rst_n) begin
        Q_next = 64'b0;
        clk_en = 1'b1;
    end
    else begin
        // Clock gating during stable states
        clk_en = ~(&Q) && ~(|Q);  // Enable unless all 1s or all 0s
        
        // Pipelined Johnson counter logic
        if (Q[0]) 
            Q_next = {1'b0, Q[63:1]};  // Count down
        else 
            Q_next = {1'b1, Q[63:1]};  // Count up
    end
end

// Pipeline stage 1
reg [63:0] Q_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q_pipe <= 64'b0;
    end
    else if (clk_en) begin
        Q_pipe <= Q_next;
    end
end

// Pipeline stage 2 (output)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end
    else if (clk_en) begin
        Q <= Q_pipe;
    end
end

endmodule