module JC_counter (
    input  wire        clk,
    input  wire        rst_n,
    output reg  [63:0] Q
);

reg [31:0] Q_high, Q_low;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q_high <= 32'b0;
        Q_low  <= 32'b0;
        Q <= 64'b0;
    end else begin
        // Insert inverted LSB of Q_low into MSB of Q_high
        Q_high <= {~Q_low[0], Q_high[31:1]};
        // Insert inverted LSB of Q_high into MSB of Q_low
        Q_low  <= {~Q_high[0], Q_low[31:1]};
        Q <= {Q_high, Q_low};
    end
end

endmodule