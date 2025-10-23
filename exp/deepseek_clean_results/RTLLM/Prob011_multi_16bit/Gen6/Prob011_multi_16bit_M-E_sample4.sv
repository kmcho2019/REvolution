module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State machine definitions
    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        BOOTH,
        ACCUM,
        DONE
    } state_t;

    // Internal registers
    reg [15:0] multiplicand;
    reg [17:0] multiplier; // Extended by 2 bits for Booth
    reg [31:0] product;
    reg [3:0] count;
    state_t state;

    // Booth encoding signals
    wire [2:0] booth_bits;
    wire [16:0] pp0, pp1, pp2, pp3;
    reg [31:0] partial_product;

    // Booth encoder
    assign booth_bits = multiplier[2:0];
    
    // Pre-compute all possible partial products
    assign pp0 = 17'b0;
    assign pp1 = {1'b0, multiplicand};
    assign pp2 = multiplicand << 1;
    assign pp3 = pp1 + pp2;

    // Booth decoder
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 32'b0;
            3'b001, 3'b010: partial_product = {15'b0, pp1, 1'b0};
            3'b011:         partial_product = {15'b0, pp2, 1'b0};
            3'b100:         partial_product = {15'b0, ~pp2 + 1'b1, 1'b0};
            3'b101, 3'b110: partial_product = {15'b0, ~pp1 + 1'b1, 1'b0};
            default:        partial_product = 32'b0;
        endcase
    end

    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            multiplicand <= 16'b0;
            multiplier <= 18'b0;
            product <= 32'b0;
            count <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                    end
                end
                
                LOAD: begin
                    multiplicand <= ain;
                    multiplier <= {bin, 2'b0}; // Pad for Booth
                    product <= 32'b0;
                    count <= 4'd8; // 16 bits / 2 bits per cycle
                    state <= BOOTH;
                end
                
                BOOTH: begin
                    // Shift product right by 2 (since we processed 2 bits)
                    product <= {partial_product[31:0] + {product[31:2]}};
                    // Shift multiplier right by 2
                    multiplier <= {2'b0, multiplier[17:2]};
                    
                    if (count == 0) begin
                        state <= DONE;
                    end
                    else begin
                        count <= count - 1;
                        state <= ACCUM;
                    end
                end
                
                ACCUM: begin
                    // Pipeline stage for better timing
                    state <= BOOTH;
                end
                
                DONE: begin
                    yout <= product;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule