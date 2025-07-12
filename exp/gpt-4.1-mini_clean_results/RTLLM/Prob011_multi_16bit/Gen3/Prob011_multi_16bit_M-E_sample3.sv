module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [15:0] ain_reg;        // Multiplicand register
    reg [15:0] bin_reg;        // Multiplier register (shifts right)
    reg [31:0] product_reg;    // Accumulator for the product
    reg [4:0]  count;          // Counts from 0 to 16 for processed bits

    // FSM states for clarity
    localparam IDLE  = 1'b0;
    localparam BUSY  = 1'b1;
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            ain_reg     <= 16'd0;
            bin_reg     <= 16'd0;
            product_reg <= 32'd0;
            count       <= 5'd0;
            done        <= 1'b0;
            yout        <= 32'd0;
            state       <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        // Load registers on start
                        ain_reg     <= ain;
                        bin_reg     <= bin;
                        product_reg <= 32'd0;
                        count       <= 5'd0;
                        state       <= BUSY;
                    end
                end

                BUSY: begin
                    if (count < 16) begin
                        // If LSB of multiplier is 1, add multiplicand shifted by count to product
                        if (bin_reg[0]) begin
                            product_reg <= product_reg + {16'd0, ain_reg};
                        end else begin
                            product_reg <= product_reg; // Hold value if bit zero
                        end

                        // Shift multiplicand left by 1 (multiply by 2)
                        ain_reg <= ain_reg << 1;

                        // Shift multiplier right by 1 (next bit)
                        bin_reg <= bin_reg >> 1;

                        // Increment count
                        count <= count + 1'b1;

                        done <= 1'b0;
                    end else begin
                        // Finished processing 16 bits
                        yout  <= product_reg;
                        done  <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule