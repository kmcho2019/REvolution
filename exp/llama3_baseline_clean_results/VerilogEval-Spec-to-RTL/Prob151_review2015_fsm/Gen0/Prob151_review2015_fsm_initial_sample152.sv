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

reg [1:0] state;
reg [3:0] shift_count;
reg pattern_detected;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        shift_count <= 0;
        pattern_detected <= 0;
    end
    else begin
        case(state)
            0: begin // Idle
                if(data == 1 && pattern_detected == 0) begin
                    pattern_detected <= 1;
                end
                else if(pattern_detected == 1 && data == 1) begin
                    pattern_detected <= 1;
                end
                else if(pattern_detected == 1 && data == 0) begin
                    pattern_detected <= 1;
                end
                else if(pattern_detected == 1 && data == 1) begin
                    pattern_detected <= 1;
                end
                else if(pattern_detected == 1 && data == 0) begin
                    state <= 1; // Shift
                    pattern_detected <= 0;
                end
                else begin
                    pattern_detected <= 0;
                end
            end
            1: begin // Shift
                shift_ena <= 1;
                if(shift_count == 4) begin
                    state <= 2; // Count
                    shift_ena <= 0;
                    shift_count <= 0;
                end
                else begin
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // Count
                counting <= 1;
                if(done_counting) begin
                    state <= 3; // Done
                    counting <= 0;
                end
            end
            3: begin // Done
                done <= 1;
                if(ack) begin
                    state <= 0; // Idle
                    done <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign shift_ena = (state == 1) ? 1 : 0;
assign counting = (state == 2) ? 1 : 0;
assign done = (state == 3) ? 1 : 0;

endmodule