module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [4:0] i;                // Gray-coded counter (0-16)
reg [15:0] areg, breg;      // Multiplicand and multiplier registers
reg [31:0] sum, carry;      // Carry-save registers
reg [31:0] product_reg;     // Final product register
reg done_r;                 // Done flag register
wire clk_gated;             // Gated clock signal
wire computation_active;    // Active computation signal

// Gray-coded counter with optimized transitions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
    end else begin
        if (start && (i < 5'd17)) begin
            case(i)
                5'd0:  i <= 5'd1;
                5'd1:  i <= 5'd3;
                5'd3:  i <= 5'd2;
                5'd2:  i <= 5'd6;
                5'd6:  i <= 5'd7;
                5'd7:  i <= 5'd5;
                5'd5:  i <= 5'd4;
                5'd4:  i <= 5'd12;
                5'd12: i <= 5'd13;
                5'd13: i <= 5'd15;
                5'd15: i <= 5'd14;
                5'd14: i <= 5'd10;
                5'd10: i <= 5'd11;
                5'd11: i <= 5'd9;
                5'd9:  i <= 5'd8;
                5'd8:  i <= 5'd16;
                5'd16: i <= 5'd17;
                default: i <= 5'd0;
            endcase
        end else if (!start) begin
            i <= 5'd0;
        end
    end
end

// Clock gating logic
assign computation_active = start && (i < 5'd17);
assign clk_gated = clk & computation_active;

// Done flag generation (simplified)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else begin
        done_r <= (i == 5'd16);
    end
end

// Pipeline stage 1: Partial product generation
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        sum <= 32'd0;
        carry <= 32'd0;
    end else begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
            sum <= 32'd0;
            carry <= 32'd0;
        end else if (i <= 5'd16) begin
            // Generate partial products using bitwise masking
            sum <= sum ^ (breg[i-1] ? (areg << (i-1)) : 32'd0);
            carry <= (sum & (breg[i-1] ? (areg << (i-1)) : 32'd0)) << 1;
        end
    end
end

// Pipeline stage 2: Final addition (registered)
always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        product_reg <= 32'd0;
    end else begin
        if (i == 5'd16) begin
            product_reg <= sum + carry;
        end
    end
end

// Output isolation
assign done = done_r;
always @(*) begin
    yout = done_r ? product_reg : 32'd0;
end

endmodule