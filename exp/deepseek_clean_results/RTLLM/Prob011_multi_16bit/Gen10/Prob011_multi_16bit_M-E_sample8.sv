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
        REDUCE,
        FINISH
    } state_t;

    state_t current_state, next_state;
    reg [3:0] cycle_count;
    reg [15:0] multiplicand;
    reg early_term;

    // Booth encoded partial products
    reg [16:0] booth_pp [0:7];
    reg [31:0] partial_sums [0:3];
    reg [31:0] final_sum;

    // Booth encoder
    always @(*) begin
        for (int i = 0; i < 8; i++) begin
            case (bin[2*i+1:2*i-1])
                3'b000, 3'b111: booth_pp[i] = 17'b0;
                3'b001, 3'b010: booth_pp[i] = {1'b0, multiplicand};
                3'b011:         booth_pp[i] = {multiplicand, 1'b0};
                3'b100:         booth_pp[i] = ~{multiplicand, 1'b0} + 1;
                3'b101, 3'b110: booth_pp[i] = ~{1'b0, multiplicand} + 1;
            endcase
        end
    end

    // Wallace tree reduction
    always @(*) begin
        // First level compression
        partial_sums[0] = {15'b0, booth_pp[0]} + ({13'b0, booth_pp[1]} << 2);
        partial_sums[1] = {11'b0, booth_pp[2]} + ({9'b0, booth_pp[3]} << 2);
        partial_sums[2] = {7'b0, booth_pp[4]} + ({5'b0, booth_pp[5]} << 2);
        partial_sums[3] = {3'b0, booth_pp[6]} + (booth_pp[7] << 2);

        // Final addition
        final_sum = partial_sums[0] + (partial_sums[1] << 4) + 
                   (partial_sums[2] << 8) + (partial_sums[3] << 12);
    end

    // Early termination detection
    always @(*) begin
        early_term = (bin == 16'b0);
    end

    // FSM control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            cycle_count <= 0;
            multiplicand <= 0;
            yout <= 0;
            done <= 0;
        end
        else begin
            current_state <= next_state;
            
            case (current_state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= ain;
                        cycle_count <= 0;
                        done <= 0;
                    end
                end
                
                BOOTH_ENCODE: begin
                    cycle_count <= cycle_count + 1;
                end
                
                REDUCE: begin
                    if (early_term) begin
                        yout <= 0;
                    end
                    else begin
                        yout <= final_sum;
                    end
                end
                
                FINISH: begin
                    done <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? BOOTH_ENCODE : IDLE;
            BOOTH_ENCODE: next_state = (cycle_count == 1) ? REDUCE : BOOTH_ENCODE;
            REDUCE: next_state = FINISH;
            FINISH: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule