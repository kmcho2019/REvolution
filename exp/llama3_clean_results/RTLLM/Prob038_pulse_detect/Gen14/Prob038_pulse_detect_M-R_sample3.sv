module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

enum logic [1:0] {
    IDLE,
    HIGH,
    HIGH_FOR_ONE_CYCLE
} state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in) begin
                    data_out <= 1'b0;
                end else begin
                    data_out <= 1'b0;
                end
            end
            HIGH: begin
                if (data_in) begin
                    data_out <= 1'b0;
                end else begin
                    data_out <= 1'b1;
                end
            end
            HIGH_FOR_ONE_CYCLE: begin
                if (data_in) begin
                    data_out <= 1'b0;
                end else begin
                    data_out <= 1'b1;
                end
            end
            default: data_out <= 1'b0;
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: begin
            if (data_in) begin
                next_state = HIGH;
            end else begin
                next_state = IDLE;
            end
        end
        HIGH: begin
            if (data_in) begin
                next_state = HIGH_FOR_ONE_CYCLE;
            end else begin
                next_state = IDLE;
            end
        end
        HIGH_FOR_ONE_CYCLE: begin
            if (data_in) begin
                next_state = HIGH;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule