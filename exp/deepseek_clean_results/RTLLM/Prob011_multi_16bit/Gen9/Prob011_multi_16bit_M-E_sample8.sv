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
    typedef enum logic [2:0] {
        IDLE,
        BOOTH,
        PP_GEN,
        ACCUM,
        FINAL,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Booth encoding signals
    reg [16:0] multiplier_ext;
    reg [2:0] booth_bits [0:7];
    reg [15:0] multiplicand;
    reg [15:0] multiplier;

    // Partial products
    reg [31:0] pp [0:7];
    reg [31:0] sum, carry;

    // Counter
    reg [2:0] count;

    // Early completion detection
    wire zero_operand = (ain == 0) || (bin == 0);

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? (zero_operand ? FINAL : BOOTH) : IDLE;
            BOOTH: next_state = PP_GEN;
            PP_GEN: next_state = ACCUM;
            ACCUM: next_state = (count == 3'd6) ? FINAL : ACCUM;
            FINAL: next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Booth encoding
    always @(posedge clk) begin
        if (current_state == BOOTH) begin
            multiplier_ext <= {multiplier, 1'b0};
            for (int i = 0; i < 8; i++) begin
                booth_bits[i] <= multiplier_ext[i*2 +: 3];
            end
        end
    end

    // Partial product generation
    always @(posedge clk) begin
        if (current_state == PP_GEN) begin
            for (int i = 0; i < 8; i++) begin
                case (booth_bits[i])
                    3'b000, 3'b111: pp[i] <= 32'b0;
                    3'b001, 3'b010: pp[i] <= {16'b0, multiplicand} << (2*i);
                    3'b011: pp[i] <= {15'b0, multiplicand, 1'b0} << (2*i);
                    3'b100: pp[i] <= ~({15'b0, multiplicand, 1'b0} << (2*i)) + 1;
                    3'b101, 3'b110: pp[i] <= ~{16'b0, multiplicand} << (2*i) + 1;
                endcase
            end
        end
    end

    // CSA tree accumulation
    always @(posedge clk) begin
        if (current_state == ACCUM) begin
            if (count == 0) begin
                {sum, carry} <= {pp[0], pp[1]};
            end else begin
                {sum, carry} <= {sum ^ carry ^ pp[count+1], 
                                (sum & carry) | (sum & pp[count+1]) | (carry & pp[count+1])} << 1;
            end
            count <= count + 1;
        end
    end

    // Final addition and output
    always @(posedge clk) begin
        if (current_state == FINAL) begin
            yout <= zero_operand ? 32'b0 : sum + carry;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

    // Operand latching
    always @(posedge clk) begin
        if (current_state == IDLE && start) begin
            multiplicand <= ain;
            multiplier <= bin;
            count <= 0;
            sum <= 0;
            carry <= 0;
        end
    end

endmodule