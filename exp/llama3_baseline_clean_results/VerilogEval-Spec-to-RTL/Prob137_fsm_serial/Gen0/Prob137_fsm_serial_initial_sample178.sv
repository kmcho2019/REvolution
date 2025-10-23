module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // IDLE, START, DATA, STOP, DONE
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;
localparam DONE_VAL = 3'b100;

reg [2:0] data_count; // count the number of data bits received
reg [7:0] data; // store the received data

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 0;
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // start bit detected
                    state <= START;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                data <= {data[6:0], in}; // shift in the new data bit
                data_count <= data_count + 1;
                if (data_count == 7) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // stop bit detected
                    state <= DONE_VAL;
                end else begin
                    // stop bit not detected, wait for stop bit
                    state <= IDLE;
                end
            end
            DONE_VAL: begin
                done <= 1'b1;
                state <= IDLE;
                data_count <= 0;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state == DONE_VAL) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule