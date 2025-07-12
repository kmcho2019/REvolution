module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg data_in_prev;
wire rising_edge = ~data_in_prev & data_in;
wire falling_edge = data_in_prev & ~data_in;

typedef enum logic [1:0] {
    IDLE,
    RISE,
    FALL
} state_t;

state_t state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
        data_in_prev <= 1'b0;
    end else begin
        data_in_prev <= data_in;
        
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (rising_edge) state <= RISE;
            end
            
            RISE: begin
                if (falling_edge) begin
                    state <= FALL;
                    data_out <= 1'b1;
                end
                else if (~data_in) state <= IDLE;
            end
            
            FALL: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule