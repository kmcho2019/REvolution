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

reg [2:0] state;
reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;  // IDLE
        count <= 4'd0;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case(state)
            3'b000: begin  // IDLE
                if (data) begin
                    state <= 3'b001;  // DETECT_PATTERN1
                end
            end
            3'b001: begin  // DETECT_PATTERN1
                if (data) begin
                    state <= 3'b010;  // DETECT_PATTERN2
                end else begin
                    state <= 3'b000;  // IDLE
                end
            end
            3'b010: begin  // DETECT_PATTERN2
                if (~data) begin
                    state <= 3'b011;  // DETECT_PATTERN3
                end else begin
                    state <= 3'b000;  // IDLE
                end
            end
            3'b011: begin  // DETECT_PATTERN3
                if (data) begin
                    state <= 3'b100;  // DETECT_PATTERN4
                end else begin
                    state <= 3'b000;  // IDLE
                end
            end
            3'b100: begin  // DETECT_PATTERN4
                if (~data) begin
                    state <= 3'b101;  // SHIFT
                    count <= 4'd0;
                    shift_ena <= 1'b1;
                end else begin
                    state <= 3'b000;  // IDLE
                end
            end
            3'b101: begin  // SHIFT
                shift_ena <= 1'b1;
                count <= count + 4'd1;
                if (count == 4'd4) begin
                    state <= 3'b110;  // COUNT
                    counting <= 1'b1;
                    shift_ena <= 1'b0;
                end
            end
            3'b110: begin  // COUNT
                if (done_counting) begin
                    state <= 3'b111;  // DONE
                    done <= 1'b1;
                    counting <= 1'b0;
                end
            end
            3'b111: begin  // DONE
                if (ack) begin
                    state <= 3'b000;  // IDLE
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule