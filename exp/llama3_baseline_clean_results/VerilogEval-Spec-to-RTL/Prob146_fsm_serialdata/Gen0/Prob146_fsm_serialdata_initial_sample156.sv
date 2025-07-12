module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: DONE
reg [2:0] data_count; // counter for data bits
reg [7:0] temp_byte; // temporary storage for data byte

always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                    data_count <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                temp_byte[7 - data_count] <= in; // store data bit
                if (data_count == 7) begin // all data bits received
                    state <= 3; // STOP
                end else begin
                    data_count <= data_count + 1;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    out_byte <= temp_byte; // output data byte
                    state <= 4; // DONE
                    done <= 1;
                end
            end
            4: begin // DONE
                done <= 0;
                if (in) begin // idle line detected
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

endmodule