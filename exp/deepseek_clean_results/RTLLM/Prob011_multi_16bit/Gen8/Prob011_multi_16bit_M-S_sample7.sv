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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Load operands and initialize
                    areg <= ain;
                    breg <= bin;
                    yout <= 32'd0;
                    count <= count + 1;
                    done <= 1'b0;
                end else if (count <= 16) begin
                    // Shift and accumulate
                    if (areg[count-1]) begin
                        yout <= yout + (breg << (count-1));
                    end
                    count <= count + 1;
                    done <= (count == 15);  // Set done one cycle early
                end else begin
                    // Multiplication complete
                    count <= 5'd0;
                    done <= 1'b1;
                end
            end else begin
                // Idle state
                count <= 5'd0;
                done <= 1'b0;
            end
        end
    end

endmodule