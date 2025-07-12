module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        CHECK,
        ADD,
        SHIFT
    } state_t;

    // Internal registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [2:0] bit_counter;
    state_t current_state;

    // FSM and datapath
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            product <= 16'b0;
            done <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    multiplicand <= A;
                    multiplier <= B;
                    accumulator <= 16'b0;
                    bit_counter <= 3'b0;
                    done <= 1'b0;
                    current_state <= CHECK;
                end
                
                CHECK: begin
                    if (bit_counter == 3'd7) begin
                        product <= accumulator;
                        done <= 1'b1;
                        current_state <= IDLE;
                    end else if (multiplier[0]) begin
                        current_state <= ADD;
                    end else begin
                        current_state <= SHIFT;
                    end
                end
                
                ADD: begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                    current_state <= SHIFT;
                end
                
                SHIFT: begin
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    bit_counter <= bit_counter + 1;
                    current_state <= CHECK;
                end
            endcase
        end
    end

endmodule