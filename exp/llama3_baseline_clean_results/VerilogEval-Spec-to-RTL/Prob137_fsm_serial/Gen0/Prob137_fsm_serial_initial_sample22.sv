module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // Define states
    parameter IDLE = 3'b000;
    parameter RECEIVE = 3'b001;
    parameter STOP = 3'b010;

    reg [2:0] state;  // Current state

    reg [7:0] data;   // Received data bits
    reg [2:0] count;  // Count of received data bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            data <= 8'b0;
            done <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        count <= 0;
                    end
                    else begin
                        state <= IDLE;
                    end
                    done <= 0;
                end

                RECEIVE: begin
                    data[7 - count] <= in;
                    count <= count + 1;
                    if (count == 8) begin
                        state <= STOP;
                    end
                    else begin
                        state <= RECEIVE;
                    end
                    done <= 0;
                end

                STOP: begin
                    if (in) begin
                        state <= IDLE;
                        done <= 1;
                    end
                    else begin
                        state <= STOP;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule