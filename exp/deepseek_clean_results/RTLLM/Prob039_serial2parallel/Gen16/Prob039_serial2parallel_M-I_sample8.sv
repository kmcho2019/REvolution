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
    reg buffer_en;
    
    // Clock gating control
    assign buffer_en = din_valid;
    
    // Circular buffer implementation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            buffer <= 8'b0;
            bit_count <= 3'b0;
            dout_parallel <= 8'b0;
        end
        else begin
            if (buffer_en) begin
                buffer[bit_count] <= din_serial;
                bit_count <= bit_count + 1'b1;
                
                // Capture parallel output when complete
                if (bit_count == 3'd7) begin
                    dout_parallel <= buffer;
                end
            end
        end
    end
    
    // Combinatorial valid signal
    assign dout_valid = (bit_count == 3'd0) & din_valid;

endmodule