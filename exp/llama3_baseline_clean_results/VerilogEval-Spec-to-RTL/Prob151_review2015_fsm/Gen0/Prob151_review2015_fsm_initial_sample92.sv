module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state; // IDLE, SHIFT, COUNT, DONE, ACK
reg [3:0] shift_count;
reg [3:0] pattern;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0; // IDLE
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern <= 0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if(pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    shift_ena <= 1;
                    pattern <= 0;
                end
                else if(data) begin
                    pattern <= {pattern[2:0], 1'b1};
                end
                else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if(shift_count == 4) begin
                    state <= 2; // COUNT
                    counting <= 1;
                    shift_ena <= 0;
                    shift_count <= 0;
                end
            end
            2: begin // COUNT
                counting <= 1;
                if(done_counting) begin
                    state <= 3; // DONE
                    done <= 1;
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if(ack) begin
                    state <= 4; // ACK
                end
            end
            4: begin // ACK
                state <= 0; // IDLE
                done <= 0;
            end
            default: state <= 0;
        endcase
    end
end

endmodule