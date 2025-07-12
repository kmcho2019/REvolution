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

reg [2:0] state;
reg [3:0] pattern;
reg [1:0] shift_count;

always_comb begin
    case (state)
        3'b000: // IDLE
            if ({pattern[2:0], data} == 4'b1101) begin
                state = 3'b001; // DETECT
            end else begin
                state = 3'b000; // IDLE
            end
        3'b001: // DETECT
            state = 3'b010; // SHIFT
        3'b010: // SHIFT
            if (shift_count == 4) begin
                state = 3'b011; // COUNT
            end else begin
                state = 3'b010; // SHIFT
            end
        3'b011: // COUNT
            if (done_counting) begin
                state = 3'b100; // DONE
            end else begin
                state = 3'b011; // COUNT
            end
        3'b100: // DONE
            if (ack) begin
                state = 3'b000; // IDLE
            end else begin
                state = 3'b100; // DONE
            end
        default: state = 3'b000; // IDLE
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: // IDLE
                pattern <= {pattern[2:0], data};
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            3'b001: // DETECT
                shift_ena <= 1'b1;
                shift_count <= 2'b00;
            3'b010: // SHIFT
                shift_ena <= 1'b1;
                shift_count <= shift_count + 1'b1;
                if (shift_count == 4) begin
                    shift_ena <= 1'b0;
                end
            3'b011: // COUNT
                counting <= 1'b1;
                shift_ena <= 1'b0;
            3'b100: // DONE
                done <= 1'b1;
                counting <= 1'b0;
                if (ack) begin
                    done <= 1'b0;
                end
        endcase
    end
end

endmodule