module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    // FSM states
    typedef enum logic [1:0] {
        LOAD,
        BIT3,
        BIT2,
        BIT1
    } state_t;

    state_t current_state, next_state;
    reg [3:0] data_latch;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= LOAD;
            data_latch <= 4'b0;
        end else begin
            current_state <= next_state;
            if (current_state == LOAD) begin
                data_latch <= d;
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            LOAD: next_state = BIT3;
            BIT3: next_state = BIT2;
            BIT2: next_state = BIT1;
            BIT1: next_state = LOAD;
            default: next_state = LOAD;
        endcase
    end

    // Output logic
    always @(*) begin
        valid_out = (current_state == LOAD);
        case (current_state)
            LOAD: dout = data_latch[3];
            BIT3: dout = data_latch[2];
            BIT2: dout = data_latch[1];
            BIT1: dout = data_latch[0];
            default: dout = 1'b0;
        endcase
    end

endmodule