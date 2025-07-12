module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [3:0] data_reg;  // Holds the parallel input data
    reg [1:0] cnt;       // 2-bit counter (0-3)
    reg active;          // Conversion in progress flag

    // Continuous assignments for outputs
    assign valid_out = active;
    assign dout = data_reg[3-cnt];  // MSB first (cnt=0 -> bit3, cnt=1 -> bit2, etc.)

    always @(posedge clk) begin
        if (!rst_n) begin
            // Synchronous reset
            data_reg <= 4'b0;
            cnt <= 2'b0;
            active <= 1'b0;
        end
        else begin
            if (!active) begin
                // Start new conversion
                data_reg <= d;
                cnt <= 2'b0;
                active <= 1'b1;
            end
            else begin
                // Continue conversion
                if (cnt == 2'b11) begin
                    // Last cycle - prepare for next conversion
                    active <= 1'b0;
                end
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule