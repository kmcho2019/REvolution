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

    // Combinatorial valid signal - pulses when 8 bits collected
    assign dout_valid = (bit_count == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            bit_count <= 3'b0;
        end
        else begin
            if (din_valid) begin
                // Shift in new bit
                buffer <= {buffer[6:0], din_serial};
                
                // Update counter
                if (bit_count == 3'd7) begin
                    bit_count <= 3'b0;
                    // Output captured immediately
                    dout_parallel <= {buffer[6:0], din_serial};
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule