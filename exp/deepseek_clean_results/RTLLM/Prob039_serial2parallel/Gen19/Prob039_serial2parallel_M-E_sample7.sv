module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    reg [7:0] circular_buffer;
    reg [2:0] write_ptr;
    reg [2:0] bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            circular_buffer <= 8'b0;
            write_ptr <= 3'b0;
            bit_count <= 3'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            dout_valid <= 1'b0;  // Default
            
            if (din_valid) begin
                // Store input at current pointer position
                circular_buffer[write_ptr] <= din_serial;
                
                // Update pointer (circular increment)
                write_ptr <= (write_ptr == 3'd7) ? 3'd0 : write_ptr + 1'b1;
                
                // Count valid inputs
                if (bit_count == 3'd7) begin
                    bit_count <= 3'd0;
                    
                    // Generate rotated output
                    case (write_ptr)
                        3'd0: dout_parallel <= circular_buffer;
                        3'd1: dout_parallel <= {circular_buffer[0], circular_buffer[7:1]};
                        3'd2: dout_parallel <= {circular_buffer[1:0], circular_buffer[7:2]};
                        3'd3: dout_parallel <= {circular_buffer[2:0], circular_buffer[7:3]};
                        3'd4: dout_parallel <= {circular_buffer[3:0], circular_buffer[7:4]};
                        3'd5: dout_parallel <= {circular_buffer[4:0], circular_buffer[7:5]};
                        3'd6: dout_parallel <= {circular_buffer[5:0], circular_buffer[7:6]};
                        3'd7: dout_parallel <= {circular_buffer[6:0], circular_buffer[7]};
                    endcase
                    
                    dout_valid <= 1'b1;
                end
                else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
        end
    end

endmodule