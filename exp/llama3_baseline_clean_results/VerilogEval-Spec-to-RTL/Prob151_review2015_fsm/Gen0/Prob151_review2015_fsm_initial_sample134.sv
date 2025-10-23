module TopModule (
    input clk, 
    input reset, 
    input data, 
    input done_counting, 
    input ack, 
    output reg shift_ena, 
    output reg counting, 
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNTING, 3: DONE
reg [1:0] counter; // counter for SHIFT state
reg [3:0] pattern; // to store the input pattern

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        pattern <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1;
                    counter <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // SHIFT
                shift_ena <= 1;
                if (counter == 4) begin
                    state <= 2;
                    shift_ena <= 0;
                end else begin
                    counter <= counter + 1;
                end
                counting <= 0;
                done <= 0;
            end
            2: begin // COUNTING
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                end
                shift_ena <= 0;
                done <= 0;
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
            end
        endcase
    end
end

endmodule