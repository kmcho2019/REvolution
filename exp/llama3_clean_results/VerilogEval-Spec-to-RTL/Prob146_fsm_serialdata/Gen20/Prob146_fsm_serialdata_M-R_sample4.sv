module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

enum logic [1:0] {
    IDLE,
    RECEIVING,
    STOP
} state, next_state;

reg [2:0] bit_counter;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 0;
        out_byte <= 8'b0;
        done <= 0;
        data <= 8'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state <= RECEIVING;
                    bit_counter <= 1;
                end
                else begin
                    state <= IDLE;
                end
            end
            RECEIVING: begin
                if (bit_counter < 8) begin
                    data <= {data[6:0], in};
                    bit_counter <= bit_counter + 1;
                    state <= RECEIVING;
                end
                else if (bit_counter == 8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    out_byte <= data;
                    done <= 1;
                    state <= IDLE;
                    bit_counter <= 0;
                end
                else begin
                    state <= STOP;
                end
            end
        endcase
    end
end

endmodule