module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    // State: 0 = waiting first byte, 1 = waiting second byte
    reg state;
    reg [7:0] data_lock;

    // Pipeline registers to delay output by one cycle after second input
    reg [15:0] pipeline_data;
    reg        pipeline_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= 1'b0;
            data_lock      <= 8'd0;
            pipeline_data  <= 16'd0;
            pipeline_valid <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            // Default clear pipeline valid each cycle unless set below
            pipeline_valid <= 1'b0;

            if (valid_in) begin
                if (state == 1'b0) begin
                    // Capture first byte, wait for second
                    data_lock <= data_in;
                    state <= 1'b1;
                end else begin
                    // Second byte received: prepare output for next cycle
                    pipeline_data  <= {data_lock, data_in};
                    pipeline_valid <= 1'b1;
                    state <= 1'b0;  // back to waiting first byte
                end
            end

            // Update output registers with delayed pipeline values
            valid_out <= pipeline_valid;
            data_out  <= pipeline_valid ? pipeline_data : data_out;
        end
    end

endmodule