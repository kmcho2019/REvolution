module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] count;  // Need 5 bits to count to 16
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Load operands
                    areg <= ain;
                    breg <= bin;
                    accumulator <= 32'd0;
                    count <= count + 1;
                    done <= 1'b0;
                end else if (count <= 16) begin
                    // Shift-and-add phase
                    if (areg[count-1]) begin
                        accumulator <= accumulator + (breg << (count-1));
                    end
                    count <= count + 1;
                    
                    // Set done when count reaches 16
                    if (count == 16) begin
                        yout <= accumulator;
                        done <= 1'b1;
                    end
                end
            end else begin
                // Reset when not started
                count <= 5'd0;
                done <= 1'b0;
            end
        end
    end

endmodule