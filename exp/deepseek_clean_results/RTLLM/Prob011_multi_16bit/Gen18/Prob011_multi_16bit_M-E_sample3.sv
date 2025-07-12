module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        INIT,
        COMPUTE,
        FINISH
    } state_t;

    // Internal registers
    reg [15:0] multiplicand;
    reg [16:0] multiplier;  // Extra bit for sign extension
    reg [31:0] product;
    reg [3:0] count;
    state_t state;

    // Precomputed multiples
    wire [31:0] multiple_0 = 32'b0;
    wire [31:0] multiple_1 = {16'b0, multiplicand};
    wire [31:0] multiple_2 = {15'b0, multiplicand, 1'b0};

    // Barrel shifter for 0/1/2 bit shifts
    function [31:0] barrel_shift;
        input [31:0] data;
        input [1:0] shift;
    begin
        case(shift)
            2'b00: barrel_shift = data;
            2'b01: barrel_shift = data << 1;
            2'b10: barrel_shift = data << 2;
            default: barrel_shift = 32'b0;
        endcase
    end
    endfunction

    // Booth encoder
    function [1:0] booth_encoding;
        input [2:0] bits;
    begin
        case(bits)
            3'b000, 3'b111: booth_encoding = 2'b00;  // 0
            3'b001, 3'b010: booth_encoding = 2'b01;  // +1
            3'b011:         booth_encoding = 2'b10;   // +2
            3'b100:         booth_encoding = 2'b10;   // -2
            3'b101, 3'b110: booth_encoding = 2'b11;   // -1
        endcase
    end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            multiplicand <= 16'b0;
            multiplier <= 17'b0;
            product <= 32'b0;
            count <= 4'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= {bin, 1'b0};  // Append 0 for LSB
                        product <= 32'b0;
                        count <= 4'd8;  // 16/2 = 8 steps
                        state <= INIT;
                    end
                end

                INIT: begin
                    state <= COMPUTE;
                end

                COMPUTE: begin
                    // Get current triplet (overlapping)
                    reg [2:0] triplet = multiplier[count*2 +: 3];
                    reg [1:0] encoding = booth_encoding(triplet);
                    reg [31:0] selected_multiple;
                    
                    // Select multiple based on encoding
                    case(encoding)
                        2'b00: selected_multiple = multiple_0;
                        2'b01: selected_multiple = multiple_1;
                        2'b10: selected_multiple = multiple_2;
                        2'b11: selected_multiple = ~multiple_1 + 1;  // Negative
                    endcase

                    // Accumulate shifted multiple
                    product <= product + barrel_shift(selected_multiple, count*2);

                    // Update counter
                    if (count == 0) begin
                        state <= FINISH;
                    end else begin
                        count <= count - 1;
                    end
                end

                FINISH: begin
                    yout <= product;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule