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
    reg [2:0] write_ptr;
    
    // Combinatorial valid signal
    assign dout_valid = (bit_count == 3'd7) & din_valid;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            dout_parallel <= 8'b0;
            bit_count <= 3'b0;
            write_ptr <= 3'b0;
        end
        else begin
            if (din_valid) begin
                // Circular buffer write
                buffer[write_ptr] <= din_serial;
                
                // Update pointer and counter
                write_ptr <= write_ptr + 1'b1;
                bit_count <= bit_count + 1'b1;
                
                // Output when full
                if (bit_count == 3'd7) begin
                    dout_parallel <= buffer;
                    bit_count <= 3'b0;
                    write_ptr <= 3'b0;
                end
            end
        end
    end

endmodule