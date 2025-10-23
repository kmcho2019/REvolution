module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

reg [1:0] state;
reg [7:0] buffer [2:0]; // 3-byte buffer
reg [1:0] counter; // counter to keep track of received bytes

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // idle state
                if (in[3]) begin // start receiving a new message
                    buffer[0] <= in;
                    counter <= 1;
                    state <= 1;
                end
                done <= 0;
            end
            1: begin // receiving state
                if (counter < 3) begin // store incoming bytes in the buffer
                    buffer[counter] <= in;
                    counter <= counter + 1;
                end else if (counter == 3) begin // message received, assert 'done' signal
                    state <= 0;
                    done <= 1;
                end
            end
        endcase
    end
end

endmodule