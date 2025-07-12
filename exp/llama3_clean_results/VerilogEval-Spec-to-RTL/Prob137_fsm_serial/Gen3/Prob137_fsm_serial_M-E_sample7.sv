module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

reg [7:0] fifo [7:0]; // FIFO buffer to store received bytes
reg [2:0] fifo_ptr; // Pointer to the current position in the FIFO
reg start_bit_detected; // Signal to indicate start bit detection
reg [7:0] data_bits; // Register to store the collected data bits
reg stop_bit_verified; // Signal to indicate stop bit verification
reg pipeline_enabled; // Signal to enable the pipeline

// Stage 1: Start bit detection
always @(posedge clk) begin
    if (reset) begin
        start_bit_detected <= 1'b0;
    end else if (!in) begin
        start_bit_detected <= 1'b1;
        pipeline_enabled <= 1'b1;
    end else begin
        start_bit_detected <= 1'b0;
    end
end

// Stage 2: Data bit collection
always @(posedge clk) begin
    if (reset) begin
        data_bits <= 8'b0;
    end else if (pipeline_enabled) begin
        data_bits <= {data_bits[6:0], in};
    end
end

// Stage 3: Stop bit verification
always @(posedge clk) begin
    if (reset) begin
        stop_bit_verified <= 1'b0;
    end else if (pipeline_enabled && data_bits == 8'b11111111) begin
        stop_bit_verified <= in;
    end
end

// FIFO management
always @(posedge clk) begin
    if (reset) begin
        fifo_ptr <= 3'b0;
    end else if (stop_bit_verified) begin
        fifo[fifo_ptr] <= data_bits;
        fifo_ptr <= fifo_ptr + 1;
        pipeline_enabled <= 1'b0;
    end
end

// Output signal generation
assign done = (fifo_ptr!= 3'b0);

endmodule