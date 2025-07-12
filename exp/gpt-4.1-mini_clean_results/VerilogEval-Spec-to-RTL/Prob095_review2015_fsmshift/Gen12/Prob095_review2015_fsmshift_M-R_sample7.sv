module TopModule (
    input  wire clk,
    input  wire reset,    // synchronous active high
    output wire shift_ena
);

    typedef enum logic [0:0] {
        IDLE  = 1'b0,
        COUNT = 1'b1
    } state_t;

    state_t state, next_state;
    reg [2:0] counter, next_counter;

    // Next state logic and counter update combinational block
    always @(*) begin
        next_state = state;
        next_counter = counter;

        case (state)
            IDLE: begin
                if (reset) begin
                    next_state = COUNT;
                    next_counter = 3'd4; // Count 4 cycles
                end
            end

            COUNT: begin
                if (counter != 0)
                    next_counter = counter - 1;
                else
                    next_state = IDLE;
            end
        endcase
    end

    // Sequential block: state and counter update on posedge clk
    always @(posedge clk) begin
        if (reset) begin
            state <= COUNT;
            counter <= 3'd4;
        end else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    assign shift_ena = (state == COUNT) && (counter != 0);

endmodule