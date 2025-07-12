module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

enum logic [2:0] {IDLE, SHIFT, COUNT, DONE} state, next_state;
reg [3:0] pattern_detector;
reg [3:0] shift_register;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern_detector <= 4'b0000;
        shift_register <= 4'b0000;
        shift_count <= 2'b00;
        counting <= 1'b0;
        done <= 1'b0;
        shift_ena <= 1'b0;
    end else begin
        pattern_detector[3:1] <= pattern_detector[2:0];
        pattern_detector[0] <= data;
        
        case (state)
            IDLE: begin
                if (pattern_detector == 4'b1101) begin
                    state <= SHIFT;
                    shift_ena <= 1'b1;
                    shift_count <= 2'b01; // Initialize shift_count to 1
                end else begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            end
            SHIFT: begin
                shift_register[3:1] <= shift_register[2:0];
                shift_register[0] <= data;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin // Check if shift_count equals 3
                    state <= COUNT;
                    counting <= 1'b1;
                    shift_ena <= 1'b0;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE;
                    done <= 1'b1;
                    counting <= 1'b0;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule