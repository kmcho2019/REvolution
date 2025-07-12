module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] bit_counter;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        bit_counter <= 0;
        data <= 8'b0;
        done <= 0;
    end else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1;
                    bit_counter <= 1;
                end
            end
            1: begin // START & DATA
                if (bit_counter == 1) begin
                    data[0] <= in;
                end else if (bit_counter > 1 && bit_counter < 9) begin
                    data[bit_counter-1] <= in;
                end
                bit_counter <= bit_counter + 1;
                if (bit_counter == 9) begin
                    if (in) begin
                        state <= 0;
                        out_byte <= {1'b0, data[6:0]};
                        done <= 1;
                    end else begin
                        state <= 0;
                    end
                end
            end
        endcase
        if (state!= 0 || bit_counter!= 9 || in) begin
            done <= 0;
        end
    end
end

endmodule