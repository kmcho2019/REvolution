module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // IDLE, RECEIVE_DATA, WAIT_STOP
reg [7:0] data;  // store the received data bits
reg [2:0] count; // count the number of received data bits

// Define the states
localparam IDLE = 3'b001;
localparam RECEIVE_DATA = 3'b010;
localparam WAIT_STOP = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        count <= 3'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (!in) begin // start bit detected
                    state <= RECEIVE_DATA;
                    data <= 8'b0;
                    count <= 3'b0;
                end
            end
            RECEIVE_DATA: begin
                data <= {data[6:0], in}; // shift in the data bit
                count <= count + 1;
                if (count == 3'b1000) begin // 8 data bits received
                    state <= WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in) begin // stop bit detected
                    state <= IDLE;
                    done <= 1'b1;
                end
            end
        endcase
    end
end

endmodule