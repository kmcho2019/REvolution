module width_8to16 (
    input        clk,
    input        rst_n,
    input        valid_in,
    input  [7:0] data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;        // Indicates if the first byte has been stored
    reg       valid_out_next;
    reg [15:0] data_out_next;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'd0;
            flag         <= 1'b0;
            valid_out    <= 1'b0;
            data_out     <= 16'd0;
        end else begin
            // Output registers update
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (valid_in) begin
                if (!flag) begin
                    // Store first data byte, wait for second
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    valid_out_next <= 1'b0;
                    data_out_next  <= 16'd0;
                end else begin
                    // On second valid data, prepare output in next cycle
                    data_out_next  <= {data_lock, data_in};
                    valid_out_next <= 1'b1;
                    flag           <= 1'b0;  // Reset flag for next pair
                end
            end else begin
                // No valid input, no output
                valid_out_next <= 1'b0;
                data_out_next  <= 16'd0;
            end
        end
    end

endmodule