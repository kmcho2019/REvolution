module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [15:0] accumulator;
    reg [7:0] shifted_A;
    reg [3:0] current_nibble;
    reg cycle;
    wire early_terminate;
    
    // Leading zero detection for early termination
    assign early_terminate = (B[7:4] == 4'b0) ? 1'b1 : 1'b0;
    
    always @(*) begin
        case (cycle)
            1'b0: current_nibble = B[3:0];  // Lower nibble
            1'b1: current_nibble = early_terminate ? 4'b0 : B[7:4]; // Upper nibble (or zero if early terminate)
        endcase
    end
    
    always @(*) begin
        // Generate partial products for current nibble
        accumulator = 0;
        if (current_nibble[0]) accumulator = shifted_A;
        if (current_nibble[1]) accumulator = accumulator + (shifted_A << 1);
        if (current_nibble[2]) accumulator = accumulator + (shifted_A << 2);
        if (current_nibble[3]) accumulator = accumulator + (shifted_A << 3);
    end
    
    always @(posedge clk) begin
        if (!reset) begin
            product <= 16'b0;
            shifted_A <= {8'b0, A};
            cycle <= 1'b0;
        end else begin
            if (cycle == 1'b0) begin
                // First cycle - process lower nibble
                product <= accumulator;
                shifted_A <= shifted_A << 4;
                cycle <= 1'b1;
            end else begin
                // Second cycle - process upper nibble or terminate
                product <= product + accumulator;
                cycle <= 1'b0;
            end
        end
    end

endmodule