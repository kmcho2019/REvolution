module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] wr_ptr;       // Write pointer (0-7)
    reg [7:0] data_buffer;  // Circular buffer storage
    wire ptr_wrap;          // Pointer wrap-around signal

    // Combinational logic
    assign ptr_wrap = (wr_ptr == 3'd7) && din_valid;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 3'b0;
            data_buffer <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            // Update buffer and pointer
            if (din_valid) begin
                data_buffer[wr_ptr] <= din_serial;
                wr_ptr <= wr_ptr + 1'b1;
            end

            // Capture output and generate valid signal
            dout_valid <= ptr_wrap;
            if (ptr_wrap) begin
                dout_parallel <= {data_buffer[6:0], din_serial};
            end
        end
    end

endmodule