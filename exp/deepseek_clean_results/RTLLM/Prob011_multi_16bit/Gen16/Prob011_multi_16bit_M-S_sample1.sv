module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Initialize registers
                    areg <= ain;
                    breg <= bin;
                    yout <= 32'b0;
                    done <= 1'b0;
                    count <= count + 1;
                end else if (count <= 16) begin
                    // Shift and accumulate
                    if (areg[count-1])
                        yout <= yout + (breg << (count-1));
                    
                    // Update counter and done signal
                    if (count == 16)
                        done <= 1'b1;
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