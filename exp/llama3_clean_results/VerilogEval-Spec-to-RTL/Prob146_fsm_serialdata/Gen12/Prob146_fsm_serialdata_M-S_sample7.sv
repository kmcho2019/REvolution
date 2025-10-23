module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1;
                    bit_counter <= 0;
                end
            end
            1: begin // START
                state <= 2;
            end
            2: begin // DATA
                data <= {data[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin
                    state <= 3;
                end
            end
            3: begin // STOP
                if (in) begin
                    out_byte <= data;
                    done <= 1;
                    state <= 0;
                end
                else begin
                    state <= 3;
                end
            end
            default: state <= 0;
        endcase
        if (state!= 3) begin
            done <= 0;
        end
    end
end

endmodule