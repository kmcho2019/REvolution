module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    parameter WIDTH = 8;
    localparam PTR_WIDTH = $clog2(WIDTH);
    
    // Gray-coded pointer for low-power operation
    reg [PTR_WIDTH-1:0] ptr_bin;
    wire [PTR_WIDTH-1:0] ptr_gray;
    reg [PTR_WIDTH-1:0] ptr_gray_reg;
    
    // Dual-stage registers
    reg [WIDTH-1:0] collect_reg;
    reg [WIDTH-1:0] output_reg;
    
    // Control signals
    wire ptr_wrap;
    reg output_ready;
    
    // Gray code conversion
    assign ptr_gray = ptr_bin ^ (ptr_bin >> 1);
    
    // Pointer wrap detection
    assign ptr_wrap = (ptr_bin == WIDTH-1);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ptr_bin <= 0;
            ptr_gray_reg <= 0;
            collect_reg <= 0;
            output_reg <= 0;
            dout_parallel <= 0;
            dout_valid <= 0;
            output_ready <= 0;
        end else begin
            // Default outputs
            dout_valid <= 0;
            
            // Serial collection phase
            if (din_valid) begin
                collect_reg[ptr_bin] <= din_serial;
                
                // Update gray-coded pointer
                ptr_bin <= ptr_wrap ? 0 : ptr_bin + 1;
                ptr_gray_reg <= ptr_gray;
                
                // Trigger output staging when buffer full
                if (ptr_wrap) begin
                    output_ready <= 1;
                end
            end
            
            // Parallel output phase
            if (output_ready) begin
                output_reg <= collect_reg;
                output_ready <= 0;
                dout_parallel <= output_reg;
                dout_valid <= 1;
            end
        end
    end

endmodule