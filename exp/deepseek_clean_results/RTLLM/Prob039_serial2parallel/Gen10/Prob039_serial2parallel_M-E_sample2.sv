module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

    // FSM states
    typedef enum logic [3:0] {
        IDLE,
        BIT0, BIT1, BIT2, BIT3,
        BIT4, BIT5, BIT6, BIT7,
        OUTPUT
    } state_t;

    state_t current_state, next_state;
    reg [7:0] data_buffer;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_buffer <= 8'b0;
            dout_parallel <= 8'b0;
            dout_valid <= 1'b0;
        end
        else begin
            current_state <= next_state;
            
            // Data collection
            case (current_state)
                BIT0: data_buffer[7] <= din_serial;
                BIT1: data_buffer[6] <= din_serial;
                BIT2: data_buffer[5] <= din_serial;
                BIT3: data_buffer[4] <= din_serial;
                BIT4: data_buffer[3] <= din_serial;
                BIT5: data_buffer[2] <= din_serial;
                BIT6: data_buffer[1] <= din_serial;
                BIT7: data_buffer[0] <= din_serial;
                OUTPUT: begin
                    dout_parallel <= data_buffer;
                    dout_valid <= 1'b1;
                end
                default: begin
                    dout_valid <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        
        if (din_valid) begin
            case (current_state)
                IDLE: next_state = BIT0;
                BIT0: next_state = BIT1;
                BIT1: next_state = BIT2;
                BIT2: next_state = BIT3;
                BIT3: next_state = BIT4;
                BIT4: next_state = BIT5;
                BIT5: next_state = BIT6;
                BIT6: next_state = BIT7;
                BIT7: next_state = OUTPUT;
                OUTPUT: next_state = BIT0;
                default: next_state = IDLE;
            endcase
        end
        else if (current_state == OUTPUT) begin
            next_state = IDLE;
        end
    end

endmodule