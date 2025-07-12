module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output wire dout_valid
);

    reg [7:0] buffer;
    reg [2:0] bit_count;
    wire buffer_en = din_valid;
    wire full = (bit_count == 3'd7);

    // Circular buffer implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            bit_count <= 3'b0;
        end
        else if (buffer_en) begin
            buffer[bit_count] <= din_serial;
            bit_count <= full ? 3'b0 : bit_count + 1'b1;
        end
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
        end
        else if (full & din_valid) begin
            dout_parallel <= buffer;
        end
    end

    // Combinatorial valid signal
    assign dout_valid = full & din_valid;

endmodule