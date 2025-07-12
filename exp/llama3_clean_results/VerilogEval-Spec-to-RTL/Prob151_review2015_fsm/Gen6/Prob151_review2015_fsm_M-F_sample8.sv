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

// State Machine
reg [2:0] state;
reg [3:0] pattern_det;
reg [3:0] shift_count;
reg [3:0] duration;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        pattern_det <= 4'b0000;
        shift_count <= 4'b0000;
        duration <= 4'b0000;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            3'b000: begin // IDLE
                pattern_det <= {pattern_det[2:0], data};
                if (pattern_det == 4'b1101) begin
                    state <= 3'b001;
                    shift_count <= 4'b0000;
                end
            end
            3'b001: begin // SHIFT
                shift_ena <= 1;
                duration <= {duration[2:0], data};
                shift_count <= shift_count + 1;
                if (shift_count == 4'b0100) begin
                    state <= 3'b010;
                    shift_ena <= 0;
                end
            end
            3'b010: begin // COUNT
                counting <= 1;
                if (done_counting) begin
                    state <= 3'b011;
                end
            end
            3'b011: begin // DONE
                counting <= 0;
                done <= 1;
                if (ack) begin
                    state <= 3'b000;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule