module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Booth encoder signals
    wire [16:0] b_ext = {bin, 1'b0};
    wire [8:0] booth_sel;
    wire [8:0][31:0] partial_products;

    // Generate Booth encoding (radix-4)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : booth_encoder
            always @(*) begin
                case (b_ext[2*i+2:2*i])
                    3'b000, 3'b111: booth_sel[i] = 2'b00;  // 0
                    3'b001, 3'b010: booth_sel[i] = 2'b01;  // +1
                    3'b011:         booth_sel[i] = 2'b10;  // +2
                    3'b100:         booth_sel[i] = 2'b11;  // -2
                    3'b101, 3'b110: booth_sel[i] = 2'b01; // -1 (treated as +1 with sign)
                endcase
            end

            // Generate partial products
            assign partial_products[i] = 
                (booth_sel[i] == 2'b00) ? 32'b0 :
                (booth_sel[i] == 2'b01) ? {{16{ain[15]}}, ain} << (2*i) :
                (booth_sel[i] == 2'b10) ? {{15{ain[15]}}, ain, 1'b0} << (2*i) :
                ~({{15{ain[15]}}, ain, 1'b0} << (2*i)) + 1;
        end
    endgenerate

    // Control FSM
    typedef enum {IDLE, PROCESSING, DONE} state_t;
    state_t state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE:       next_state = start ? PROCESSING : IDLE;
            PROCESSING:  next_state = DONE;
            DONE:       next_state = IDLE;
            default:    next_state = IDLE;
        endcase
    end

    // Wallace tree reduction (3:2 compressors)
    wire [31:0] sum1, carry1;
    wire [31:0] sum2, carry2;
    wire [31:0] sum3, carry3;
    
    // First level compression
    compressor_3_2 level1 [31:0] (
        .a(partial_products[0]),
        .b(partial_products[1]),
        .c(partial_products[2]),
        .sum(sum1),
        .carry(carry1)
    );

    // Second level compression
    compressor_3_2 level2 [31:0] (
        .a(partial_products[3]),
        .b(partial_products[4]),
        .c(partial_products[5]),
        .sum(sum2),
        .carry(carry2)
    );

    // Third level compression
    compressor_3_2 level3 [31:0] (
        .a(sum1),
        .b(carry1 << 1),
        .c(sum2),
        .sum(sum3),
        .carry(carry3)
    );

    // Final addition (CLA)
    wire [31:0] final_sum = sum3 + (carry2 << 1) + (carry3 << 1) + partial_products[6] + partial_products[7];

    // Output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                PROCESSING: begin
                    yout <= final_sum;
                    done <= 1'b1;
                end
                default: done <= 1'b0;
            endcase
        end
    end

endmodule

// 3:2 compressor module
module compressor_3_2 (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [31:0] c,
    output wire [31:0] sum,
    output wire [31:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (a & c);
endmodule