module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1
} state_t;

reg [1:0] state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        // Output is only high for one cycle when sequence completes
        data_out <= (state == GOT_1) && !data_in;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            next_state = data_in ? IDLE : GOT_0;
        end
        
        GOT_0: begin
            if (data_in)
                next_state = GOT_1;  // Valid rising edge
            else
                next_state = GOT_0;  // Stay until we see 1
        end
        
        GOT_1: begin
            if (!data_in)
                next_state = IDLE;   // Valid falling edge - sequence complete
            else
                next_state = IDLE;   // Reset if pulse stays high too long
        end
        
        default: next_state = IDLE;
    endcase
end

endmodule