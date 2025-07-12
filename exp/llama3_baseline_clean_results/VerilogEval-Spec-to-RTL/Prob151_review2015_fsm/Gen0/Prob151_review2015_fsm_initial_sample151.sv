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

reg [3:0] state; // IDLE, SHIFT, COUNT, DONE
reg [3:0] shift_count; // Counter for shift operation
reg [3:0] pattern; // Register to store the pattern
reg detect_pattern; // Flag to detect the pattern 1101

// Define states
parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNT = 4'd2;
parameter DONE_ACK = 4'd3;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 4'd0;
        pattern <= 4'd0;
        detect_pattern <= 1'b0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                // Shift in the data to detect the pattern
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    detect_pattern <= 1'b1;
                    state <= SHIFT;
                end
                else begin
                    detect_pattern <= 1'b0;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_count == 4'd3) begin
                    shift_ena <= 1'b0;
                    shift_count <= 4'd0;
                    state <= COUNT;
                end
                else begin
                    shift_count <= shift_count + 1'b1;
                end
            end
            COUNT: begin
                counting <= 1'b1;
                if (done_counting) begin
                    counting <= 1'b0;
                    state <= DONE_ACK;
                end
            end
            DONE_ACK: begin
                done <= 1'b1;
                if (ack) begin
                    done <= 1'b0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule