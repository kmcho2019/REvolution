module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Booth encoding states
    typedef enum logic [3:0] {
        IDLE,
        INIT,
        BOOTH0, BOOTH1, BOOTH2, BOOTH3, 
        BOOTH4, BOOTH5, BOOTH6,
        FINISH
    } state_t;

    // FSM signals
    state_t current_state, next_state;
    reg [3:0] booth_idx;
    reg [31:0] accumulator;
    reg [31:0] a_neg, a_pos, a_2pos, a_2neg;
    reg [15:0] bin_reg;

    // Booth encoding window
    wire [2:0] booth_window;
    assign booth_window = (booth_idx == 0) ? {bin_reg[0], 1'b0} : 
                         (booth_idx == 15) ? {bin_reg[15], bin_reg[14:14]} :
                         bin_reg[booth_idx +: 2];

    // FSM transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: next_state = start ? INIT : IDLE;
            INIT: next_state = BOOTH0;
            BOOTH0, BOOTH1, BOOTH2, BOOTH3, 
            BOOTH4, BOOTH5, BOOTH6: begin
                if (booth_idx >= 14) next_state = FINISH;
                else next_state = state_t'(current_state + 1);
            end
            FINISH: next_state = IDLE;
        endcase
    end

    // Datapath operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
            booth_idx <= 4'b0;
            a_neg <= 32'b0;
            a_pos <= 32'b0;
            a_2pos <= 32'b0;
            a_2neg <= 32'b0;
            bin_reg <= 16'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    done <= 1'b0;
                    accumulator <= 32'b0;
                end
                INIT: begin
                    // Precompute all possible partial products
                    a_pos <= {16'b0, ain};
                    a_neg <= {16'b0, ~ain + 1'b1};
                    a_2pos <= {15'b0, ain, 1'b0};
                    a_2neg <= {15'b0, ~ain + 1'b1, 1'b0};
                    bin_reg <= bin;
                    booth_idx <= 4'b0;
                end
                BOOTH0, BOOTH1, BOOTH2, BOOTH3, 
                BOOTH4, BOOTH5, BOOTH6: begin
                    case (booth_window)
                        3'b000, 3'b111: ; // No operation
                        3'b001, 3'b010: accumulator <= accumulator + (a_pos << booth_idx);
                        3'b011: accumulator <= accumulator + (a_2pos << booth_idx);
                        3'b100: accumulator <= accumulator + (a_2neg << booth_idx);
                        3'b101, 3'b110: accumulator <= accumulator + (a_neg << booth_idx);
                    endcase
                    booth_idx <= booth_idx + 2;
                end
                FINISH: begin
                    yout <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule