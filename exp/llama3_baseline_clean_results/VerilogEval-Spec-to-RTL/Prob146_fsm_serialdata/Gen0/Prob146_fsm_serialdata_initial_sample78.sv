module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // 0: IDLE, 1: DATA, 2: STOP
reg [7:0] data; // received data byte
reg [2:0] count; // data bit counter
reg done_reg; // done signal register

// IDLE state
parameter IDLE = 3'b000;

// DATA state
parameter DATA = 3'b001;

// STOP state
parameter STOP = 3'b010;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
        data <= 8'b0;
        done_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (!in) begin // start bit detected
                    state <= DATA;
                    count <= 1;
                    data <= {7'b0, in}; // store the first data bit (LSB)
                end
            end
            DATA: begin
                data <= {data[6:0], in}; // shift in the next data bit
                count <= count + 1;
                if (count == 8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= IDLE;
                    out_byte <= data;
                end else begin
                    state <= STOP; // wait for stop bit
                end
            end
        endcase
        if (state != STOP) begin
            done_reg <= 0; // clear done signal
        end
    end
end

assign done = done_reg;

endmodule