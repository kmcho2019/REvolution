module TopModule(
    input clk, 
    input reset, 
    input data, 
    input done_counting, 
    input ack, 
    output shift_ena, 
    output counting, 
    output done
);

reg [2:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] shift_count;
reg [3:0] pattern;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        pattern <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= 1;
                end else begin
                    state <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // SHIFT
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2;
                    shift_count <= 0;
                end else begin
                    state <= 1;
                end
                counting <= 0;
                done <= 0;
            end
            2: begin // COUNT
                shift_ena <= 0;
                counting <= 1;
                if (done_counting) begin
                    state <= 3;
                end else begin
                    state <= 2;
                end
                done <= 0;
            end
            3: begin // DONE
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
                if (ack) begin
                    state <= 0;
                end else begin
                    state <= 3;
                end
            end
        endcase
    end
end

endmodule