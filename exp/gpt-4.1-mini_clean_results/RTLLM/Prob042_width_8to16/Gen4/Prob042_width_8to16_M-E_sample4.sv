module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;       // Store first byte
    reg       half_full;       // 0: waiting for first byte, 1: waiting for second byte

    reg       valid_out_d;     // delayed valid_out (one cycle after concatenation)
    reg [15:0] data_out_d;     // delayed data_out (pipeline stage)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock   <= 8'd0;
            half_full   <= 1'b0;
            data_out_d  <= 16'd0;
            valid_out_d <= 1'b0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            valid_out_d <= 1'b0; // default: no valid output this cycle

            if (valid_in) begin
                if (!half_full) begin
                    // Store first byte and wait for second
                    data_lock <= data_in;
                    half_full <= 1'b1;
                end else begin
                    // Second byte arrives: form 16-bit data (first byte high, second byte low)
                    data_out_d  <= {data_lock, data_in};
                    valid_out_d <= 1'b1;
                    half_full   <= 1'b0;
                end
            end

            // Register output signals to produce valid_out and data_out delayed by one cycle after concatenation
            valid_out <= valid_out_d;
            data_out  <= data_out_d;
        end
    end

endmodule