module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // Idle, Start, Data, Stop
reg [2:0] counter; // counter for data bits
reg [7:0] data; // register to hold the received data

parameter IDLE = 3'b001;
parameter START = 3'b010;
parameter DATA = 3'b011;
parameter STOP = 3'b100;

always @ (posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
        counter <= 3'b000;
    end
    else begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                end
            end
            START: begin
                state <= DATA;
                counter <= 3'b000;
                data <= 8'b0;
            end
            DATA: begin
                data <= {data[6:0], in}; // shift in the new bit
                if (counter == 3'b111) begin
                    state <= STOP;
                end
                else begin
                    counter <= counter + 1'b1;
                end
            end
            STOP: begin
                if (in) begin
                    state <= IDLE;
                    done <= 1'b1; // assert 'done' signal
                end
            end
        endcase
    end
end

// Reset 'done' signal at the next clock cycle
always @ (posedge clk) begin
    if (!reset && state != STOP) begin
        done <= 1'b0;
    end
end

endmodule