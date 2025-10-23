module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] count;         // Count cycles, max 16
    reg [31:0] product;      // Accumulator for product
    reg [15:0] multiplicand; // Stored multiplicand
    reg [15:0] multiplier;   // Stored multiplier shifted right each cycle
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            product <= 32'd0;
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
            done <= 1'b0;
            yout <= 32'd0;
            busy <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Start multiplication: load inputs, reset product and count
                multiplicand <= ain;
                multiplier <= bin;
                product <= 32'd0;
                count <= 5'd0;
                done <= 1'b0;
                busy <= 1'b1;
            end else if (busy) begin
                // During multiplication operation
                if (multiplier[0]) begin
                    product <= product + {{16{1'b0}}, multiplicand};
                end
                multiplier <= multiplier >> 1;
                count <= count + 1;

                if (count == 5'd15) begin
                    // Done after 16 cycles (0 to 15)
                    done <= 1'b1;
                    busy <= 1'b0;
                    yout <= product + (multiplier[0] ? {{16{1'b0}}, multiplicand} : 32'd0); 
                    // The addition for the last bit is done here in product before assignment
                    // Actually product was updated this cycle after multiplier shift, so just assign product
                    // Correction: because product was updated before multiplier shift, no extra add needed here.
                    // So just assign product directly:
                    yout <= product;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule