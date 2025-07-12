module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] pattern; // to store the input pattern
reg [1:0] shift_counter; // counter for the shift state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // IDLE
        pattern <= 0;
        shift_counter <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if(pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    pattern <= 0;
                    shift_counter <= 0;
                end
                else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                pattern <= {pattern[2:0], data};
                shift_counter <= shift_counter + 1;
                if(shift_counter == 4) begin
                    state <= 2; // COUNT
                    shift_ena <= 0;
                end
            end
            2: begin // COUNT
                counting <= 1;
                if(done_counting) begin
                    state <= 3; // DONE
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if(ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule