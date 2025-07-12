module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Need 5 bits to count to 16 (0-15) plus overflow
    reg [15:0] multiplicand;
    reg [31:0] product;
    reg running;

    // Done flag generation
    assign done = (count == 16);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            multiplicand <= 16'b0;
            product <= 32'b0;
            yout <= 32'b0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                // Start new multiplication
                multiplicand <= ain;
                product <= 32'b0;
                count <= 5'd0;
                running <= 1'b1;
            end else if (running) begin
                if (count < 16) begin
                    // Shift-and-add operation
                    if (bin[count]) begin
                        product <= product + (multiplicand << count);
                    end
                    count <= count + 1;
                end else begin
                    // Multiplication complete
                    yout <= product;
                    running <= 1'b0;
                end
            end
        end
    end

endmodule