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
        INIT,
        CALC,
        FINISH
    } state_t;

    // Internal registers
    reg [15:0] multiplicand;
    reg [16:0] multiplier;  // Extra bit for Booth encoding
    reg [31:0] product;
    reg [3:0] counter;
    state_t state;

    // Booth encoding cases
    wire [2:0] booth_bits;
    wire [31:0] partial_product;
    wire [31:0] shifted_multiplicand;

    assign booth_bits = multiplier[2:0];
    assign shifted_multiplicand = {multiplicand, 16'b0};

    // Partial product selection
    always_comb begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 32'b0;
            3'b001, 3'b010: partial_product = {16'b0, multiplicand};
            3'b011:         partial_product = {15'b0, multiplicand, 1'b0};
            3'b100:         partial_product = ~{15'b0, multiplicand, 1'b0} + 1;
            3'b101, 3'b110: partial_product = ~{16'b0, multiplicand} + 1;
            default:        partial_product = 32'b0;
        endcase
    end

    // Main state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            multiplicand <= 16'b0;
            multiplier <= 17'b0;
            product <= 32'b0;
            counter <= 4'b0;
            done <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= INIT;
                    end
                end

                INIT: begin
                    multiplicand <= ain;
                    multiplier <= {bin, 1'b0};  // Add extra bit for Booth
                    product <= 32'b0;
                    counter <= 4'd0;
                    state <= CALC;
                end

                CALC: begin
                    // Accumulate partial product (arithmetically shifted)
                    product <= product + (partial_product >>> (counter * 2));
                    
                    // Shift multiplier right by 2 bits for next Booth group
                    multiplier <= multiplier >> 2;
                    
                    if (counter == 4'd7) begin
                        state <= FINISH;
                    end
                    else begin
                        counter <= counter + 1;
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