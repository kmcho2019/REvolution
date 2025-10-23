module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Generate a gated clock signal using a level-sensitive latch
logic gated_clk;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gated_clk <= 1'b0;
    end else if (valid_count) begin
        gated_clk <= 1'b1;
    end else begin
        gated_clk <= 1'b0;
    end
end

// Synchronize the gated clock signal with the system clock
logic sync_gated_clk;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_gated_clk <= 1'b0;
    end else begin
        sync_gated_clk <= gated_clk;
    end
end

// Use a Gray code counter to reduce switching activity
logic [3:0] gray_out;
always @(posedge sync_gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        gray_out <= 4'b0000;
    end else if (sync_gated_clk) begin
        // Increment the Gray code counter
        gray_out <= gray_out + 1;
    end
end

// Convert the Gray code to binary
always @(*) begin
    case (gray_out)
        4'b0000: out = 4'd0;
        4'b0001: out = 4'd1;
        4'b0011: out = 4'd2;
        4'b0010: out = 4'd3;
        4'b0110: out = 4'd4;
        4'b0111: out = 4'd5;
        4'b0101: out = 4'd6;
        4'b0100: out = 4'd7;
        4'b1100: out = 4'd8;
        4'b1101: out = 4'd9;
        4'b1111: out = 4'd10;
        4'b1110: out = 4'd11;
        default: out = 4'b0000;
    endcase
end

endmodule