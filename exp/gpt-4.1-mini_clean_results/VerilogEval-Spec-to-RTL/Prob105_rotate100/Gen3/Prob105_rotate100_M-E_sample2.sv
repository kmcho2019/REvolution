module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Split 100-bit register into two 50-bit halves
    reg [49:0] upper_half; // q[99:50]
    reg [49:0] lower_half; // q[49:0]

    always @(posedge clk) begin
        if (load) begin
            // Synchronous load into both halves
            upper_half <= data[99:50];
            lower_half <= data[49:0];
        end else begin
            case (ena)
                2'b10: begin
                    // Rotate left by one bit:
                    // upper_half shifts left, LSB replaced by MSB of lower_half
                    // lower_half shifts left, LSB replaced by MSB of upper_half
                    // But since it's one 100-bit rotate left, MSB of upper_half (bit 49) rotates to LSB of lower_half (bit 0)
                    // and lower_half shifts left by one.
                    // First, save MSB of upper_half for lower_half LSB
                    // and MSB of lower_half for upper_half LSB after shifting
                    // Actually, for rotate left by one on 100 bits:
                    // q = {q[98:0], q[99]} 
                    // Map this to halves:
                    // upper_half = {upper_half[48:0], lower_half[49]}
                    // lower_half = {lower_half[48:0], upper_half[49]}
                    // To do it stepwise:

                    reg upper_msb, lower_msb;
                    upper_msb = upper_half[49];  // MSB of upper_half = q[99]
                    lower_msb = lower_half[49];  // MSB of lower_half = q[49]

                    // new upper_half = {upper_half[48:0], lower_msb}
                    // new lower_half = {lower_half[48:0], upper_msb}

                    upper_half <= {upper_half[48:0], lower_msb};
                    lower_half <= {lower_half[48:0], upper_msb};
                end

                2'b01: begin
                    // Rotate right by one bit:
                    // q = {q[0], q[99:1]}
                    // Map to halves:
                    // upper_half = {lower_half[0], upper_half[49:1]}
                    // lower_half = {lower_half[0], upper_half[0]}
                    // To carefully implement:
                    reg upper_lsb, lower_lsb;
                    upper_lsb = upper_half[0]; // LSB of upper_half = q[50]
                    lower_lsb = lower_half[0]; // LSB of lower_half = q[0]

                    // New upper_half = {lower_lsb, upper_half[49:1]}
                    // New lower_half = {lower_half[49:1], upper_lsb}

                    upper_half <= {lower_lsb, upper_half[49:1]};
                    lower_half <= {lower_half[49:1], upper_lsb};
                end

                default: begin
                    // No rotation; retain current halves
                    upper_half <= upper_half;
                    lower_half <= lower_half;
                end
            endcase
        end
    end

    // Concatenate halves to form q
    always @* begin
        q = {upper_half, lower_half};
    end

endmodule