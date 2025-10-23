module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    input  logic        test_mode,  // Test mode signal
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic inc_clk;
logic [3:0] next_out;
logic [1:0] clk_sync;

// Synchronization of valid_count with clk
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_sync <= 2'b00;
    end else begin
        clk_sync <= {clk_sync[0], valid_count};
    end
end

// Generation of inc_clk
assign inc_clk = clk_sync[1] &&!clk_sync[0];

// Counter logic
always_comb begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (test_mode) begin
        // BIST sequence
        next_out = (out == 4'd11)? 4'b0000 : out + 1;
    end else if (inc_clk) begin
        next_out = (out == 4'd11)? 4'b0000 : out + 1;
    end else begin
        next_out = out;
    end
end

// Sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule