module TopModule (
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

// Initialize q at startup for FPGA synthesis; in ASIC, use external reset as needed
initial begin
    q = 4'b0000;
end

always @(posedge clk) begin
    if (shift_ena) begin
        q <= {q[2:0], data};
    end else if (count_ena) begin
        q <= q - 1;
    end
    // else hold q without assignment for power saving
end

endmodule