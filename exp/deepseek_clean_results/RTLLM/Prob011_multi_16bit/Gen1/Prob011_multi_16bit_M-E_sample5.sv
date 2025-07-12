module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // Iteration counter (0-8)
    reg [15:0] areg;        // Multiplicand register
    reg [17:0] breg;        // Multiplier register (with 2 guard bits)
    reg [31:0] pp_sum;      // Partial product sum
    reg [31:0] pp_carry;    // Partial product carry
    reg done_r;             // Done flag

    // Modified Booth encoding for unsigned numbers
    wire [1:0] booth_sel;
    wire [16:0] pp;
    wire [15:0] zero_ext = 16'b0;
    wire [15:0] areg_neg = ~areg + 1;

    assign booth_sel = breg[1:0];
    assign pp = (booth_sel == 2'b00) ? {1'b0, zero_ext} :
                (booth_sel == 2'b01) ? {1'b0, areg} :
                (booth_sel == 2'b10) ? {1'b0, areg} << 1 :
                {1'b0, areg_neg} << 1;  // For 2's complement of 2*areg

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 18'd0;
            pp_sum <= 32'd0;
            pp_carry <= 32'd0;
            done_r <= 1'b0;
            yout <= 32'd0;
        end else begin
            if (start) begin
                if (i == 4'd0) begin
                    // Initialize registers
                    areg <= ain;
                    breg <= {bin, 2'b0};  // Add guard bits
                    pp_sum <= 32'd0;
                    pp_carry <= 32'd0;
                    done_r <= 1'b0;
                    i <= i + 1;
                end else if (i < 4'd8) begin
                    // Check for early termination
                    if (breg[17:2] == 16'd0) begin
                        i <= 4'd8;  // Skip to final addition
                    end else begin
                        // Carry-save addition of partial product
                        {pp_carry, pp_sum} <= 
                            {pp_carry[30:0], 1'b0} + 
                            pp_sum + 
                            (pp << (2*(i-1)));
                        
                        // Shift multiplier right by 2
                        breg <= breg >> 2;
                        i <= i + 1;
                    end
                end else if (i == 4'd8) begin
                    // Final addition
                    yout <= pp_sum + (pp_carry << 1);
                    done_r <= 1'b1;
                    i <= i + 1;
                end else begin
                    // Clear done after one cycle
                    done_r <= 1'b0;
                    i <= 4'd0;
                end
            end else begin
                // Clear when not started
                i <= 4'd0;
                done_r <= 1'b0;
            end
        end
    end

    assign done = done_r;

endmodule