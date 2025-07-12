module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output         valid_out,
    output [15:0]  data_out
);

    reg [7:0] data_lock;       // Stores first valid byte
    reg       data_lock_flag;  // Indicates if first byte is stored

    reg       valid_out_reg;
    reg [15:0] data_out_reg;

    // Temporary signal indicating second valid byte received this cycle
    wire second_byte_received = valid_in && data_lock_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock       <= 8'd0;
            data_lock_flag  <= 1'b0;
            valid_out_reg   <= 1'b0;
            data_out_reg    <= 16'd0;
        end else begin
            valid_out_reg <= 1'b0; // default no output valid each cycle

            if (second_byte_received) begin
                // Concatenate stored first byte (high) and current byte (low)
                data_out_reg  <= {data_lock, data_in};
                valid_out_reg <= 1'b1;
                data_lock_flag <= 1'b0; // clear stored byte after forming output
            end else if (valid_in && !data_lock_flag) begin
                // Store first byte and set flag
                data_lock      <= data_in;
                data_lock_flag <= 1'b1;
            end
        end
    end

    assign valid_out = valid_out_reg;
    assign data_out  = data_out_reg;

endmodule