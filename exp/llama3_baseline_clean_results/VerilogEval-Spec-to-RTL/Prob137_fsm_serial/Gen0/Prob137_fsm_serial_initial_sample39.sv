module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

reg [2:0] state; // 0 - IDLE, 1 - START, 2 - DATA, 3 - STOP, 4 - ERROR
reg [2:0] data_counter; // counts the number of data bits received
reg        prev_stop; // indicates if the previous state was STOP

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data_counter <= 0;
        prev_stop <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit
                    state <= 1; // START
                    data_counter <= 0;
                end else begin
                    state <= 0; // IDLE
                end
                prev_stop <= 0;
                if (prev_stop) begin
                    done <= 1;
                end else begin
                    done <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_counter <= 0;
                prev_stop <= 0;
                done <= 0;
            end
            2: begin // DATA
                if (data_counter == 7) begin // 8 data bits received
                    state <= 3; // STOP
                end
                data_counter <= data_counter + 1;
                prev_stop <= 0;
                done <= 0;
            end
            3: begin // STOP
                if (in) begin // stop bit
                    state <= 0; // IDLE
                    prev_stop <= 1;
                end else begin
                    state <= 4; // ERROR
                    prev_stop <= 0;
                end
                done <= 0;
            end
            4: begin // ERROR
                if (in) begin // stop bit
                    state <= 0; // IDLE
                    prev_stop <= 0;
                end else begin
                    state <= 4; // ERROR
                    prev_stop <= 0;
                end
                done <= 0;
            end
        endcase
    end
end

endmodule