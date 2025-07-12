module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    reg [1:0] cnt;
    reg       enable;

    // Enable is high during serialization cycle (4 cycles)
    // For simplicity, always enable since new input is always loaded every 4 cycles.
    // Alternatively, could be gated from external control signal.

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            valid_out <= 1'b0;
            dout      <= 1'b0;
            enable    <= 1'b1;  // always enabled in this version
        end else begin
            if (cnt == 2'd3) begin
                cnt       <= 2'b00;
                valid_out <= 1'b1; // valid during the last bit output cycle as well
            end else begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b1; // valid during serialization (all 4 bits)
            end
            // Registered output of current bit from d
            dout <= d[3 - cnt];
        end
    end

endmodule