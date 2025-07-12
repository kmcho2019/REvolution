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
    typedef enum logic [1:0] {
        IDLE,
        GEN_PARTIAL,
        REDUCE,
        OUTPUT
    } state_t;

    // Internal registers
    state_t state, next_state;
    reg [15:0] multiplicand;
    reg [31:0] partial_products [0:15];
    reg [31:0] sum, carry;
    reg [3:0] reduction_stage;

    // Generate all partial products in parallel
    always @(*) begin
        for (int i = 0; i < 16; i++) begin
            partial_products[i] = ain[i] ? (bin << i) : 32'b0;
        end
    end

    // Wallace tree reduction
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sum <= 32'b0;
            carry <= 32'b0;
            reduction_stage <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= ain;
                        sum <= 32'b0;
                        carry <= 32'b0;
                        reduction_stage <= 4'b0;
                        done <= 1'b0;
                    end
                end
                
                GEN_PARTIAL: begin
                    // First stage of carry-save addition
                    {carry, sum} = partial_products[0] + partial_products[1] + partial_products[2];
                    reduction_stage <= 1;
                end
                
                REDUCE: begin
                    // Subsequent reduction stages
                    if (reduction_stage < 5) begin
                        case (reduction_stage)
                            1: {carry, sum} = {carry, sum} + partial_products[3] + partial_products[4] + partial_products[5];
                            2: {carry, sum} = {carry, sum} + partial_products[6] + partial_products[7] + partial_products[8];
                            3: {carry, sum} = {carry, sum} + partial_products[9] + partial_products[10] + partial_products[11];
                            4: {carry, sum} = {carry, sum} + partial_products[12] + partial_products[13] + partial_products[14];
                            5: {carry, sum} = {carry, sum} + partial_products[15];
                        endcase
                        reduction_stage <= reduction_stage + 1;
                    end
                end
                
                OUTPUT: begin
                    // Final addition
                    yout <= sum + carry;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? GEN_PARTIAL : IDLE;
            GEN_PARTIAL: next_state = REDUCE;
            REDUCE: next_state = (reduction_stage == 5) ? OUTPUT : REDUCE;
            OUTPUT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule