module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

// Reset synchronizer block
reg reset_sync;
reg reset_sync_reg;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        reset_sync <= 1'b1;
        reset_sync_reg <= 1'b1;
    end else begin
        reset_sync <= 1'b0;
        reset_sync_reg <= reset_sync;
    end
end

// Main flip-flop with synchronized reset
reg q_reg;
always @(posedge clk) begin
    if (reset_sync_reg) q_reg <= 1'b0;
    else                q_reg <= d;
end

assign q = q_reg;

endmodule