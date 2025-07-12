module TopModule(
    input           clk,
    input           in,
    input           reset,
    output [7:0]    out_byte,
    output          done
);

reg [2:0] state; // 0 - idle, 1 - start, 2 - data, 3 - stop
reg [7:0] data;  // data byte
reg [2:0] cnt;   // counter for data bits
reg [7:0] out_byte_reg; // register for output byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to idle state
        cnt <= 0;
        out_byte_reg <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // idle state
                if (!in) begin // start bit detected
                    state <= 1;
                    cnt <= 0;
                    data <= 0;
                end
            end
            1: begin // start state
                state <= 2; // move to data state
            end
            2: begin // data state
                data[cnt] <= in; // store data bit
                cnt <= cnt + 1;
                if (cnt == 7) begin // all data bits received
                    state <= 3;
                end
            end
            3: begin // stop state
                if (in) begin // stop bit detected
                    out_byte_reg <= {data[6], data[5], data[4], data[3], data[2], data[1], data[0], 1'b0}; // store data byte and assert done
                    done <= 1;
                    state <= 0; // move back to idle state
                end else begin // incorrect stop bit
                    state <= 0; // move back to idle state and wait for stop bit
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    out_byte <= out_byte_reg;
    if (!done) begin
        out_byte_reg <= 0;
    end
    if (state != 3) begin
        done <= 0;
    end
end

endmodule