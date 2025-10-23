module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0] data_lock;       // Stores first input byte
    reg       data_lock_valid; // Indicates if data_lock holds valid data

    reg [15:0] data_pipeline;  // Holds concatenated data to output next cycle
    reg        valid_pipeline; // Indicates if data_pipeline is valid to output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock       <= 8'd0;
            data_lock_valid <= 1'b0;
            data_pipeline   <= 16'd0;
            valid_pipeline  <= 1'b0;
            data_out        <= 16'd0;
            valid_out       <= 1'b0;
        end else begin
            valid_out <= valid_pipeline;      // Assert valid_out one cycle after second byte captured
            data_out  <= data_pipeline;

            valid_pipeline <= 1'b0; // Default deassert valid_pipeline each cycle unless set below

            if (valid_in) begin
                if (!data_lock_valid) begin
                    // Store first byte
                    data_lock       <= data_in;
                    data_lock_valid <= 1'b1;
                end else begin
                    // Second byte arrived, prepare output next cycle
                    data_pipeline   <= {data_lock, data_in}; // first byte high, second byte low
                    valid_pipeline  <= 1'b1;
                    data_lock_valid <= 1'b0; // Clear lock after second byte used
                end
            end
        end
    end

endmodule