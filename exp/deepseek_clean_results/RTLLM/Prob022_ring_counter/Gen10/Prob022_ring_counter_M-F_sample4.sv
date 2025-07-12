module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

// One-hot rotating register with synchronous reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end else begin
        // Rotate left with wrap-around
        out <= {out[6:0], out[7]};
    end
end

// Initial block for simulation (not synthesizable)
initial begin
    out = 8'b00000001;
end

endmodule