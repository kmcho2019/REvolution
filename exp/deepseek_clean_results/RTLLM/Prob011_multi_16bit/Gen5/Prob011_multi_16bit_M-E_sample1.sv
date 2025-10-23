module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] state;        // 0-9 states (4 bits)
    reg [15:0] multiplicand;
    reg [16:0] multiplier;  // Extra bit for Booth encoding
    reg [31:0] accumulator;
    reg zero_flag;
    wire [1:0] booth_bits;

    // Booth encoding bits (current pair + previous LSB)
    assign booth_bits = multiplier[1:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 4'd0;
            multiplicand <= 16'd0;
            multiplier <= 17'd0;
            accumulator <= 32'd0;
            done <= 1'b0;
            zero_flag <= 1'b0;
        end
        else begin
            done <= 1'b0;  // Default done to 0

            if (start) begin
                case (state)
                    4'd0: begin  // Initialization state
                        multiplicand <= ain;
                        multiplier <= {bin, 1'b0};  // Append 0 for Booth
                        accumulator <= 32'd0;
                        zero_flag <= (bin == 16'd0);
                        state <= zero_flag ? 4'd9 : 4'd1;  // Skip if zero
                    end
                    default: begin  // Processing states 1-8
                        if (state < 4'd9) begin
                            case (booth_bits)
                                2'b01: accumulator <= accumulator + {multiplicand, 1'b0};
                                2'b10: accumulator <= accumulator - {multiplicand, 1'b0};
                                2'b11: accumulator <= accumulator - multiplicand;
                                2'b00: accumulator <= accumulator + multiplicand;
                            endcase
                            
                            // Arithmetic right shift of multiplier
                            multiplier <= {accumulator[0], multiplier[16:1]};
                            // Right shift accumulator with sign extension
                            accumulator <= {accumulator[31], accumulator[31:1]};
                            
                            state <= state + 4'd1;
                        end
                        else if (state == 4'd9) begin  // Completion state
                            done <= 1'b1;
                            state <= 4'd0;
                        end
                    end
                endcase
            end
            else begin  // Not started
                state <= 4'd0;
                accumulator <= 32'd0;
            end
        end
    end

    // Output assignment (registered for better timing)
    always @(posedge clk) begin
        if (done) begin
            yout <= accumulator;
        end
    end

endmodule