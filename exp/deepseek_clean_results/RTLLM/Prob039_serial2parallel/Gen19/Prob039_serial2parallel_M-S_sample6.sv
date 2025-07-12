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

    assign dout_valid = (bit_count == 3'b111) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            bit_count <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else if (din_valid) begin
            buffer <= {buffer[6:0], din_serial};
            
            if (bit_count == 3'b111) begin
                dout_parallel <= {buffer[6:0], din_serial};
                bit_count <= 3'b0;
            end
            else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end

endmodule