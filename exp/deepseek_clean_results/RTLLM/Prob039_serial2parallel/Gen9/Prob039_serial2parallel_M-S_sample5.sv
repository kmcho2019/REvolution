module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [2:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'b0;
            cnt <= 3'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default assignment
            
            if (din_valid) begin
                // Shift in new bit (MSB first)
                dout_parallel <= {din_serial, dout_parallel[7:1]};
                
                // Update counter and generate valid pulse
                if (cnt == 3'd7) begin
                    cnt <= 3'b0;
                    dout_valid <= 1'b1;
                end
                else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule