module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [2:0] cnt;        // 3-bit counter (0-7)
    reg [7:0] buffer;     // Shift register for serial input
    wire buffer_update;
    wire counter_reset;

    // Continuous assignments
    assign buffer_update = din_valid;
    assign counter_reset = (cnt == 3'd7) & din_valid;
    assign dout_valid = counter_reset;

    // Shift register implementation (MSB first)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
        end
        else if (buffer_update) begin
            buffer <= {buffer[6:0], din_serial};
        end
    end

    // Counter implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'b0;
        end
        else if (counter_reset) begin
            cnt <= 3'b0;
        end
        else if (buffer_update) begin
            cnt <= cnt + 1'b1;
        end
    end

    // Parallel output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (counter_reset) begin
            dout_parallel <= {buffer[6:0], din_serial};
        end
    end

endmodule