module TopModule (
    input         clk,
    input         reset,
    input         data,
    output [3:0]  count,
    output        counting,
    output        done,
    input         ack
);

reg [3:0] state; // Idle, Shift, Counting, Done
reg [3:0] delay;
reg [9:0] counter; // counter for counting down
reg [3:0] bit_counter; // counter for number of bits received in Shift state
reg [3:0] pattern; // pattern detector
reg [3:0] temp_count; // temporary count for output

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        counter <= 0;
        bit_counter <= 0;
        pattern <= 0;
        delay <= 0;
        temp_count <= 0;
        done <= 0;
        counting <= 0;
    end
    else begin
        case (state)
            0: begin // Idle
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 1; // Shift
                    pattern <= 0;
                end
            end
            1: begin // Shift
                delay <= {delay[2:0], data};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4) begin
                    state <= 2; // Counting
                    counter <= (delay + 1) * 1000 - 1;
                    bit_counter <= 0;
                    counting <= 1;
                end
            end
            2: begin // Counting
                counter <= counter - 1;
                if (counter == ((delay) * 1000 - 1)) begin
                    temp_count <= delay;
                end
                else if (counter == ((delay - 1) * 1000 - 1)) begin
                    temp_count <= delay - 1;
                end
                else if (counter == ((delay - 2) * 1000 - 1)) begin
                    temp_count <= delay - 2;
                end
                else if (counter == ((delay - 3) * 1000 - 1)) begin
                    temp_count <= delay - 3;
                end
                if (counter == 0) begin
                    state <= 3; // Done
                    done <= 1;
                    counting <= 0;
                end
            end
            3: begin // Done
                if (ack) begin
                    state <= 0; // Idle
                    done <= 0;
                end
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        2: begin
            count <= temp_count;
        end
        default: begin
            count <= 4'bxxxx;
        end
    endcase
end

endmodule