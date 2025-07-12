module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    reg [7:0] stored_data;    // holds the first incoming byte
    reg       has_data;       // 1 when first byte stored, waiting for second byte

    // Registers to hold output data and valid signal with 1 cycle delay
    reg [15:0] data_out_reg;
    reg        valid_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_data    <= 8'd0;
            has_data       <= 1'b0;
            data_out_reg   <= 16'd0;
            valid_out_reg  <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            valid_out      <= valid_out_reg;   // valid output delayed by 1 cycle
            data_out       <= data_out_reg;    // output delayed by 1 cycle
            
            valid_out_reg  <= 1'b0;             // default no valid output this cycle

            if (valid_in) begin
                if (!has_data) begin
                    // Store first byte and mark as waiting for second
                    stored_data <= data_in;
                    has_data    <= 1'b1;
                end else begin
                    // Second byte arrived: form 16-bit word and output next cycle
                    data_out_reg  <= {stored_data, data_in};
                    valid_out_reg <= 1'b1;

                    // Clear has_data to accept next pair
                    has_data     <= 1'b0;
                end
            end
        end
    end

endmodule