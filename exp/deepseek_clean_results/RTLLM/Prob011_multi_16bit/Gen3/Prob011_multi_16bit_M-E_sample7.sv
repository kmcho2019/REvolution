module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        BOOTH_ENCODE,
        WALLACE_REDUCE,
        FINAL_ADD
    } state_t;

    // Internal registers
    state_t state, next_state;
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] partial_products [0:8];
    reg [31:0] sum, carry;
    reg early_term;

    // Booth encoder
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            case (multiplier[i*2+1:i*2-1])  // Overlapping 3-bit groups
                3'b000, 3'b111: partial_products[i] = 32'b0;
                3'b001, 3'b010: partial_products[i] = {16'b0, multiplicand} << (i*2);
                3'b011:         partial_products[i] = {15'b0, multiplicand, 1'b0} << (i*2);
                3'b100:         partial_products[i] = -({15'b0, multiplicand, 1'b0} << (i*2));
                3'b101, 3'b110: partial_products[i] = -({16'b0, multiplicand} << (i*2));
            endcase
        end
        partial_products[8] = {multiplier[15], multiplier[15:0], 16'b0}; // Sign extension
    end

    // Wallace tree reduction (simplified 3:2 compressors)
    always @(*) begin
        sum = partial_products[0] ^ partial_products[1] ^ partial_products[2];
        carry = {partial_products[0] & partial_products[1] | 
                partial_products[0] & partial_products[2] | 
                partial_products[1] & partial_products[2], 1'b0};
        
        for (int i = 3; i < 9; i++) begin
            sum = sum ^ carry ^ partial_products[i];
            carry = {sum & carry | sum & partial_products[i] | 
                    carry & partial_products[i], 1'b0};
        end
    end

    // FSM and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            multiplicand <= 16'b0;
            multiplier <= 16'b0;
            yout <= 32'b0;
            done <= 1'b0;
            early_term <= 1'b0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= bin;
                        early_term <= (bin == 16'b0);
                        next_state <= early_term ? FINAL_ADD : BOOTH_ENCODE;
                    end
                end
                
                BOOTH_ENCODE: begin
                    next_state <= WALLACE_REDUCE;
                end
                
                WALLACE_REDUCE: begin
                    next_state <= FINAL_ADD;
                end
                
                FINAL_ADD: begin
                    yout <= sum + carry;
                    done <= 1'b1;
                    next_state <= IDLE;
                end
            endcase
        end
    end

    // Early termination output
    always @(*) begin
        if (early_term && state == FINAL_ADD)
            yout = 32'b0;
    end

endmodule