module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        PROCESS = 2'b01,
        DONE = 2'b10
    } state_t;
    reg [1:0] state, next_state;

    reg [16:0] multiplicand; // sign-extended multiplicand
    reg [16:0] product;      // product register (accumulator + multiplier + extra bit)
    reg [2:0] count;         // 3 bits to count up to 4 cycles (for 8-bit radix-4)

    wire [2:0] booth_bits;
    assign booth_bits = product[2:0];

    // Booth operation combinational function
    function [16:0] booth_op;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_op = 17'd0;
                3'b001, 3'b010: booth_op =  multiplicand;
                3'b011:         booth_op =  multiplicand << 1;
                3'b100:         booth_op = -(multiplicand << 1);
                3'b101, 3'b110: booth_op = -multiplicand;
                default:        booth_op = 17'd0;
            endcase
        end
    endfunction

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= PROCESS;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:     next_state = reset ? PROCESS : IDLE;
            PROCESS:  next_state = (count == 3'd4) ? DONE : PROCESS;
            DONE:     next_state = reset ? PROCESS : DONE;
            default:  next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk) begin
        if (reset) begin
            // Load inputs with sign extension
            multiplicand <= {{9{a[7]}}, a};
            product <= {{8{b[7]}}, b, 1'b0};
            count <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                end
                PROCESS: begin
                    // Add/subtract according to Booth encoding and shift right 2 bits
                    product <= (product >>> 2) + (booth_op(booth_bits) << 1);
                    count <= count + 1;
                end
                DONE: begin
                    p <= product[16:1]; // exclude the extra bit
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule