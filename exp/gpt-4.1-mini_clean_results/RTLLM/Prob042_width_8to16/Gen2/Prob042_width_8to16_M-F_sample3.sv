module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0] data_lock;
    reg       flag;
    reg       output_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock    <= 8'd0;
            flag         <= 1'b0;
            output_ready <= 1'b0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
        end else begin
            valid_out <= 1'b0; // Default no output this cycle

            if (output_ready) begin
                // Output concatenated data and assert valid_out
                valid_out <= 1'b1;
                output_ready <= 1'b0;
                // data_out was updated last cycle when second input arrived, so stable now
            end

            if (valid_in) begin
                if (!flag) begin
                    // Store first data byte in high 8 bits position
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second valid input arrives
                    // Concatenate first and second input for output in next cycle
                    data_out <= {data_lock, data_in};
                    output_ready <= 1'b1;
                    flag <= 1'b0; // Clear flag to accept next first input
                end
            end
        end
    end

endmodule