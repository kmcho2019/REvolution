module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // 0 - IDLE, 1 - START, 2 - DATA, 3 - STOP
reg [7:0] data; // received data
reg [2:0] count; // count of data bits
reg [7:0] temp; // temporary storage for data

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        count <= 0;
        data <= 8'b0;
        temp <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                    count <= 0;
                    temp <= 8'b0;
                end
            end
            1: begin // START
                state <= 2; // DATA
                count <= 0;
            end
            2: begin // DATA
                temp[count] <= in;
                count <= count + 1;
                if (count == 7) begin
                    state <= 3; // STOP
                    data <= {temp[7], temp[6], temp[5], temp[4], temp[3], temp[2], temp[1], temp[0]}; // flip the bits
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done <= 1'b1;
                end else begin // stop bit not detected
                    state <= 1; // START
                    count <= 0;
                    temp <= 8'b0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 0 && in == 1'b1) begin // IDLE and line is high
        done <= 1'b0;
    end
end

endmodule