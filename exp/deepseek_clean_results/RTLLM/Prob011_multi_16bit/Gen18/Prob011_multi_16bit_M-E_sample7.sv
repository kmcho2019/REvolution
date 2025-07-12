module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] count;  // Only need 0-8 (4 bits)
    reg [15:0] areg;
    reg [16:0] breg;  // Extended by 1 bit for Booth encoding
    reg [31:0] partial;
    reg [1:0] booth_bits;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'd0;
            areg <= 16'b0;
            breg <= 17'b0;
            partial <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Initialize registers
                    areg <= ain;
                    breg <= {bin, 1'b0};  // Append 0 for Booth encoding
                    partial <= 32'b0;
                    yout <= 32'b0;
                    done <= 1'b0;
                    count <= count + 1;
                end else if (count <= 8) begin
                    // Get current Booth encoding bits
                    booth_bits <= breg[1:0];
                    
                    // Process Booth encoding cases
                    case (booth_bits)
                        2'b00, 2'b11: partial <= partial;
                        2'b01: partial <= partial + {areg, 1'b0};
                        2'b10: partial <= partial - {areg, 1'b0};
                    endcase
                    
                    // Shift right for next iteration
                    breg <= {2'b0, breg[16:2]};
                    partial <= partial >>> 2;
                    
                    // Update counter and done signal
                    if (count == 8) begin
                        yout <= partial;
                        done <= 1'b1;
                    end
                    count <= count + 1;
                end
            end else begin
                // Reset when not started
                count <= 4'd0;
                done <= 1'b0;
            end
        end
    end

endmodule