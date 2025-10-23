module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

reg [3:0] bit_count; // Counter for received bits
reg [7:0] data_reg; // Shift register for received data bits
reg done_reg;
reg idle_reg;

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        bit_count <= 4'b0;
        data_reg <= 8'b0;
        done_reg <= 1'b0;
        idle_reg <= 1'b1;
    end else begin
        if (idle_reg) begin // Idle state
            if (!in) begin // Detect start bit
                idle_reg <= 1'b0;
                bit_count <= 4'b1;
                data_reg <= {7'b0, in};
            end
        end else if (bit_count < 9) begin // Receiving state
            bit_count <= bit_count + 1;
            data_reg <= {data_reg[6:0], in};
        end else if (in) begin // Stop state
            done_reg <= 1'b1; // Signal byte reception
            idle_reg <= 1'b1; // Transition back to idle state
        end else begin // Wait for stop bit
            bit_count <= 4'b0; // Reset counter
            data_reg <= 8'b0; // Reset data register
        end
    end
end

assign done = done_reg;

endmodule