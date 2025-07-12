module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3 states: IDLE, START, DATA, STOP, DONE
reg [7:0] data; // 8-bit data register
reg [3:0] count; // 4-bit counter for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        data <= 8'b0;
        count <= 4'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (~in) begin // start bit detected
                    state <= 1; // transition to START state
                    count <= 4'b0;
                    data <= 8'b0;
                end
            end
            1: begin // START state
                state <= 2; // transition to DATA state
            end
            2: begin // DATA state
                data <= {data[6:0], in}; // shift in the data bit
                count <= count + 1'b1;
                if (count == 4'd8) begin
                    state <= 3; // transition to STOP state
                end
            end
            3: begin // STOP state
                if (in) begin // stop bit detected
                    state <= 4; // transition to DONE state
                end
            end
            4: begin // DONE state
                done <= 1'b1; // signal done
                state <= 0; // transition back to IDLE state
                data <= 8'b0;
                count <= 4'b0;
            end
            default: state <= 0; // default to IDLE state
        endcase
    end
end

endmodule