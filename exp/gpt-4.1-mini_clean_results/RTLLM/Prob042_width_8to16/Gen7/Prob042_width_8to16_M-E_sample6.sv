module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;           // store first byte
    reg        has_first_byte;      // flag: first byte stored

    reg [15:0] data_out_reg;        // pipeline register for output data
    reg        valid_out_reg;       // pipeline register for valid_out

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock      <= 8'd0;
            has_first_byte <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_reg   <= 16'd0;
            valid_out_reg  <= 1'b0;
        end else begin
            valid_out      <= valid_out_reg;
            data_out       <= data_out_reg;

            valid_out_reg  <= 1'b0;  // default, set to 1 when output ready

            if (valid_in) begin
                if (!has_first_byte) begin
                    // First byte arrives: store it, no output yet
                    data_lock      <= data_in;
                    has_first_byte <= 1'b1;
                end else begin
                    // Second byte arrives: prepare concatenated output
                    data_out_reg   <= {data_lock, data_in};
                    valid_out_reg  <= 1'b1;

                    // Clear first byte flag since pair completed
                    has_first_byte <= 1'b0;
                end
            end
        end
    end

endmodule