module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [31:0] ipc_out_a, ipc_out_b; // Output of IPC stage
reg [23:0] mmea_out_mantissa; // Output of MMEA stage
reg [8:0] mmea_out_exponent; // Output of MMEA stage
reg [31:0] rnu_out; // Output of RNU stage
reg [31:0] ofsch_out; // Output of OFSCH stage

// Stage 1: Input Processing and Classification (IPC)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        ipc_out_a <= 32'b0;
        ipc_out_b <= 32'b0;
    end else begin
        // Extract sign, exponent, and mantissa
        reg a_sign, b_sign;
        reg [8:0] a_exponent, b_exponent;
        reg [23:0] a_mantissa, b_mantissa;
        
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
        
        // Classify inputs
        if ((a_exponent == 9'b11111111) || (b_exponent == 9'b11111111)) begin
            // Handle NaN and infinity cases
            if ((a_exponent == 9'b11111111) && (a_mantissa!= 23'b0)) begin
                ipc_out_a <= 32'b1; // NaN
            end else if ((b_exponent == 9'b11111111) && (b_mantissa!= 23'b0)) begin
                ipc_out_b <= 32'b1; // NaN
            end else if (a_exponent == 9'b11111111) begin
                ipc_out_a <= (a_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
            end else begin
                ipc_out_b <= (b_sign)? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
            end
        end else begin
            ipc_out_a <= {a_sign, a_exponent, a_mantissa};
            ipc_out_b <= {b_sign, b_exponent, b_mantissa};
        end
    end
end

// Stage 2: Mantissa Multiplier and Exponent Adjuster (MMEA)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        mmea_out_mantissa <= 24'b0;
        mmea_out_exponent <= 9'b0;
    end else begin
        // Multiply mantissas
        reg [49:0] product;
        product <= {1'b1, ipc_out_a[22:0]} * {1'b1, ipc_out_b[22:0]};
        
        // Adjust exponent
        mmea_out_exponent <= ipc_out_a[30:23] + ipc_out_b[30:23] - 9'b10000000;
        
        // Extract mantissa
        mmea_out_mantissa <= product[48:25];
    end
end

// Stage 3: Rounding and Normalization Unit (RNU)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        rnu_out <= 32'b0;
    end else begin
        // Apply rounding rules
        reg [23:0] rounded_mantissa;
        reg guard_bit, round_bit, sticky;
        guard_bit <= mmea_out_mantissa[24];
        round_bit <= mmea_out_mantissa[23];
        sticky <= |mmea_out_mantissa[22:0];
        
        if (guard_bit || round_bit || sticky) begin
            rounded_mantissa <= mmea_out_mantissa + 1;
        end else begin
            rounded_mantissa <= mmea_out_mantissa;
        end
        
        // Normalize mantissa
        if (rounded_mantissa[23] == 1'b0) begin
            rounded_mantissa <= rounded_mantissa << 1;
            mmea_out_exponent <= mmea_out_exponent - 1;
        end
        
        // Format output
        rnu_out <= {ipc_out_a[31], mmea_out_exponent, rounded_mantissa};
    end
end

// Stage 4: Output Formatting and Special Case Handler (OFSCH)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        ofsch_out <= 32'b0;
    end else begin
        // Handle special cases
        if ((ipc_out_a[30:23] == 9'b11111111) || (ipc_out_b[30:23] == 9'b11111111)) begin
            ofsch_out <= (ipc_out_a[31])? 32'b1000_0000_0000_0000_0000_0000_0000_0000 : 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Infinity
        end else begin
            ofsch_out <= rnu_out;
        end
    end
end

// Output assignment
assign z = ofsch_out;

endmodule