module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Define states using enum for better readability
    typedef enum reg [2:0] {
        IDLE    = 3'b001,  // Waiting for first '0'
        GOT_0   = 3'b010,  // Got 0, waiting for 1
        GOT_1   = 3'b100   // Got 1, waiting for final 0
    } state_t;

    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:   next_state = (data_in == 1'b0) ? GOT_0 : IDLE;
            GOT_0:  next_state = (data_in == 1'b1) ? GOT_1 : GOT_0;
            GOT_1:  next_state = (data_in == 1'b0) ? GOT_0 : GOT_1;
            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Output logic: data_out is asserted for one cycle at pulse end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 1'b0;
        end else begin
            // data_out = 1 when transitioning from GOT_1 and data_in=0 (pulse ends)
            data_out <= (state == GOT_1 && data_in == 1'b0);
        end
    end

endmodule