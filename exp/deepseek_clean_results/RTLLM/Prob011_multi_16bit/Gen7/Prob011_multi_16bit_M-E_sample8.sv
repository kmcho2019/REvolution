module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        BOOTH_ENCODE,
        ACCUMULATE,
        FINISH
    } state_t;
    
    state_t state, next_state;
    
    // Booth encoding signals
    reg [16:0] b_ext;
    wire [2:0] booth_bits [0:7];
    reg [2:0] current_booth;
    reg [3:0] booth_idx;
    
    // Partial products
    reg [31:0] partial [0:1];
    reg [31:0] sum, carry;
    
    // Early termination flag
    wire zero_multiplier = (bin == 16'd0);
    
    // Generate Booth encoding bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : booth_enc
            assign booth_bits[i] = b_ext[2*i +: 3];
        end
    endgenerate
    
    // Booth decoder
    always_comb begin
        case (current_booth)
            3'b000, 3'b111: partial[0] = 32'd0;
            3'b001, 3'b010: partial[0] = {16'd0, ain} << (booth_idx * 2);
            3'b011:         partial[0] = {15'd0, ain, 1'b0} << (booth_idx * 2);
            3'b100:         partial[0] = -({15'd0, ain, 1'b0} << (booth_idx * 2));
            3'b101, 3'b110: partial[0] = -({16'd0, ain} << (booth_idx * 2));
        endcase
    end
    
    // 3:2 compressor for partial product accumulation
    always_comb begin
        {carry, sum} = {1'b0, sum} + {1'b0, carry} + {1'b0, partial[0]};
    end
    
    // State machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            yout <= 32'd0;
            done <= 1'b0;
            b_ext <= 17'd0;
            booth_idx <= 4'd0;
            sum <= 32'd0;
            carry <= 32'd0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        b_ext <= {bin, 1'b0};
                        booth_idx <= 4'd0;
                        sum <= 32'd0;
                        carry <= 32'd0;
                    end
                end
                
                BOOTH_ENCODE: begin
                    current_booth <= booth_bits[booth_idx];
                end
                
                ACCUMULATE: begin
                    sum <= sum;
                    carry <= carry;
                    booth_idx <= booth_idx + 1;
                end
                
                FINISH: begin
                    yout <= sum + carry;
                    done <= 1'b1;
                end
            endcase
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = zero_multiplier ? FINISH : BOOTH_ENCODE;
            BOOTH_ENCODE: next_state = ACCUMULATE;
            ACCUMULATE: next_state = (booth_idx == 7) ? FINISH : BOOTH_ENCODE;
            FINISH: next_state = IDLE;
        endcase
    end

endmodule