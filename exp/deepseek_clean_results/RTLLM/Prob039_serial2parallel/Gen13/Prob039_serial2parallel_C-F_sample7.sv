module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    parameter WIDTH = 8;
    
    reg [WIDTH-1:0] buffer;
    reg [2:0] bit_ptr;  // Circular buffer pointer
    reg [3:0] bit_count; // Counts 0-7 then wraps

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= {WIDTH{1'b0}};
            dout_parallel <= {WIDTH{1'b0}};
            bit_ptr <= 3'b0;
            bit_count <= 4'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default
            
            if (din_valid) begin
                // Circular buffer write
                buffer[bit_ptr] <= din_serial;
                
                // Pointer and counter update
                bit_ptr <= (bit_ptr == WIDTH-1) ? 3'b0 : bit_ptr + 1'b1;
                bit_count <= bit_count + 1'b1;
                
                // Output generation on full byte
                if (bit_count == WIDTH-1) begin
                    dout_parallel <= buffer;
                    dout_valid <= 1'b1;
                end
            end
        end
    end

endmodule