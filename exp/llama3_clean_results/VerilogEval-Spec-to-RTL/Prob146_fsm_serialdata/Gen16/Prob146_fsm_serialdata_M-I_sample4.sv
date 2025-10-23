module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

parameter IDLE = 2'b00, RECEIVING = 2'b01, STOPPING = 2'b10;
reg [1:0] state;
reg [1:0] next_state;
reg [7:0] data;
reg [2:0] bit_counter;
reg [2:0] next_bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state)
            IDLE: begin
                if (!in) begin
                    next_state <= RECEIVING;
                    next_bit_counter <= 1;
                    data <= {7'b0, in};
                end
                else begin
                    next_state <= IDLE;
                    next_bit_counter <= 0;
                end
            end
            RECEIVING: begin
                if (bit_counter < 8) begin
                    next_state <= RECEIVING;
                    next_bit_counter <= bit_counter + 1;
                    data <= {data[6:0], in};
                end
                else begin
                    next_state <= STOPPING;
                    next_bit_counter <= 0;
                end
            end
            STOPPING: begin
                next_state <= IDLE;
                next_bit_counter <= 0;
                if (in) begin
                    done <= 1;
                    out_byte <= data;
                end
                else begin
                    done <= 0;
                end
            end
        endcase
        state <= next_state;
        bit_counter <= next_bit_counter;
    end
end

endmodule