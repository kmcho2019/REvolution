module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]     bit_idx;      // Counter: which bit of bin we are processing (0 to 16)
    reg [15:0]    ain_reg;      // Register to hold multiplicand
    reg [15:0]    bin_reg;      // Register to hold multiplier
    reg [31:0]    acc;          // Accumulator holding partial sum (product)
    reg           done_r;

    // Control FSM-like counter logic and done flag management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_idx <= 5'd0;
            done_r  <= 1'b0;
        end else begin
            if (start) begin
                if (bit_idx < 5'd16) begin
                    bit_idx <= bit_idx + 5'd1;
                    done_r <= 1'b0;
                end else if (bit_idx == 5'd16) begin
                    // Completed 16 bits multiplication
                    done_r <= 1'b1;
                    // bit_idx stays at 16 until start deasserted or reset
                end
            end else begin
                bit_idx <= 5'd0;
                done_r  <= 1'b0;
            end
        end
    end

    // Registers to load inputs at start signal rising edge
    // and accumulate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ain_reg <= 16'd0;
            bin_reg <= 16'd0;
            acc     <= 32'd0;
        end else begin
            if (start) begin
                if (bit_idx == 5'd0) begin
                    // Load inputs and reset accumulator at start
                    ain_reg <= ain;
                    bin_reg <= bin;
                    acc     <= 32'd0;
                end else if (bit_idx >= 5'd1 && bit_idx <= 5'd16) begin
                    // For bit index i (1 to 16), check bit (i-1) of bin_reg
                    // If that bit is 1, add ain_reg shifted left by (i-1)
                    if (bin_reg[bit_idx - 5'd1])
                        acc <= acc + ( {16'd0, ain_reg} << (bit_idx - 5'd1) );
                    else
                        acc <= acc;
                end else begin
                    // Hold accumulator stable when done or waiting
                    acc <= acc;
                end
            end else begin
                // When start is low, clear registers and accumulator
                ain_reg <= 16'd0;
                bin_reg <= 16'd0;
                acc     <= 32'd0;
            end
        end
    end

    assign yout = acc;
    assign done = done_r;

endmodule