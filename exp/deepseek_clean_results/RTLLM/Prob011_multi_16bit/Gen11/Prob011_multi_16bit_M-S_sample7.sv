module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [4:0] count;  // Need 5 bits to count 0-16
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] product;

assign done = (count == 5'd16);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 5'd0;
        areg <= 16'b0;
        breg <= 16'b0;
        product <= 32'b0;
        yout <= 32'b0;
    end
    else begin
        if (start) begin
            if (count == 5'd0) begin
                // Load operands
                areg <= ain;
                breg <= bin;
                product <= 32'b0;
                count <= count + 1;
            end
            else if (count <= 5'd16) begin
                // Shift and accumulate
                if (areg[count-1]) begin
                    product <= product + (breg << (count-1));
                end
                
                if (count == 5'd16) begin
                    yout <= product;
                end
                
                count <= count + 1;
            end
        end
        else begin
            count <= 5'd0;
            yout <= 32'b0;
        end
    end
end

endmodule