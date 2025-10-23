module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [3:0] i;            // Reduced to 4-bit counter (0-15)
reg [15:0] areg, breg;  // Operand registers
reg [31:0] product;     // Product register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 4'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        product <= 32'd0;
        done <= 1'b0;
    end else begin
        if (start) begin
            if (i == 4'd0) begin
                // Initialize operation
                areg <= ain;
                breg <= bin;
                product <= 32'd0;
                done <= 1'b0;
                i <= i + 1;
            end else if (i <= 4'd15) begin
                // Shift-and-add step
                if (breg[i-1]) begin
                    product <= product + (areg << (i-1));
                end
                i <= i + 1;
                done <= (i == 4'd15) ? 1'b1 : 1'b0;
            end else begin
                // Operation complete
                i <= 4'd0;
                done <= 1'b0;
            end
        end else begin
            i <= 4'd0;
            done <= 1'b0;
        end
    end
end

// Direct output assignment
always @(*) begin
    yout = product;
end

endmodule