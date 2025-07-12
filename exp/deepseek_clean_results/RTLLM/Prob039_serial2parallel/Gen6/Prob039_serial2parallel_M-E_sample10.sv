module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_ready
);

    reg [7:0] buffer;
    reg [2:0] wptr;  // Write pointer (0-7)
    reg full_flag;

    // Continuous output - always reflects current buffer contents
    always @(*) begin
        dout_parallel = buffer;
    end

    // Ready signal pulses high when buffer is full
    assign dout_ready = full_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr <= 3'b0;
            buffer <= 8'b0;
            full_flag <= 1'b0;
        end
        else begin
            full_flag <= 1'b0;  // Default to not ready

            if (din_valid) begin
                // Store incoming bit at current pointer position
                buffer[wptr] <= din_serial;

                // Update pointer with wrap-around
                if (wptr == 3'd7) begin
                    wptr <= 3'd0;
                    full_flag <= 1'b1;  // Pulse ready when buffer fills
                end
                else begin
                    wptr <= wptr + 1'b1;
                end
            end
        end
    end

endmodule