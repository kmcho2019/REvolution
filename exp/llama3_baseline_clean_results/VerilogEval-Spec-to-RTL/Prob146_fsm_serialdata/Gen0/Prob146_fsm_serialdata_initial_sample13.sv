module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: idle, 1: receive, 2: stop
reg [2:0] bit_counter;
reg [7:0] byte_register;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // idle
        bit_counter <= 0;
        byte_register <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (!in) begin // start bit detected
                    state <= 1; // move to receive state
                    bit_counter <= 1;
                    byte_register[0] <= in;
                end
            end
            1: begin // receive
                byte_register[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= 2; // move to stop state
                end
            end
            2: begin // stop
                if (in) begin // stop bit detected
                    out_byte <= byte_register; // assign received byte to output
                    done <= 1; // signal done
                    state <= 0; // return to idle state
                    bit_counter <= 0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state != 2) begin
        done <= 0; // clear done signal unless in stop state
    end
end

endmodule