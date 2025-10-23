module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] a_reg, b_reg;
    reg [31:0] product;
    reg [3:0] cycle; // 4-bit counter (0-15)
    reg active;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset
            a_reg <= 16'b0;
            b_reg <= 16'b0;
            product <= 32'b0;
            cycle <= 4'b0;
            active <= 1'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else begin
            // Default assignments
            done <= 1'b0;

            if (start && !active) begin
                // Start new multiplication
                a_reg <= ain;
                b_reg <= bin;
                product <= 32'b0;
                cycle <= 4'b0;
                active <= 1'b1;
            end
            else if (active) begin
                if (cycle < 15) begin
                    // Processing cycles
                    if (a_reg[cycle]) begin
                        product <= product + (b_reg << cycle);
                    end
                    cycle <= cycle + 1;
                end
                else begin
                    // Final cycle (cycle == 15)
                    if (a_reg[15]) begin
                        product <= product + (b_reg << 15);
                    end
                    
                    // Multiplication complete
                    yout <= product + (a_reg[15] ? (b_reg << 15) : 32'b0);
                    done <= 1'b1;
                    active <= 1'b0;
                end
            end
        end
    end

endmodule