module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] count;       // 0-16 counter
    reg [15:0] areg;       // Multiplicand register
    reg [15:0] breg;       // Multiplier register
    reg [31:0] acc;        // Accumulator
    reg running;           // Operation in progress flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
            running <= 1'b0;
        end
        else begin
            if (start && !running) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                acc <= 32'd0;
                count <= 5'd0;
                running <= 1'b1;
                done <= 1'b0;
            end
            else if (running) begin
                if (count < 16) begin
                    // Perform shift-and-add
                    if (areg[count]) begin
                        acc <= acc + (breg << count);
                    end
                    count <= count + 1;
                end
                else begin
                    // Multiplication complete
                    yout <= acc;
                    done <= 1'b1;
                    running <= 1'b0;
                end
            end
            else begin
                done <= 1'b0;
            end
        end
    end

endmodule