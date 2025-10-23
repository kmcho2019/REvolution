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

reg [2:0] shift_count; // Counter for shifting
reg [3:0] curr_pattern; // Register to store the current input pattern

always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 3'b000;
        curr_pattern <= 4'b0000;
    end else begin
        curr_pattern[3:1] <= curr_pattern[2:0];
        curr_pattern[0] <= data;
        
        case (curr_pattern)
            4'b1101: begin
                if (shift_count == 4) begin
                    counting <= 1'b1;
                    shift_ena <= 1'b0;
                    shift_count <= 3'b000;
                end else begin
                    shift_ena <= 1'b1;
                    shift_count <= shift_count + 1'b1;
                end
            end
            default: begin
                if (shift_count == 4) begin
                    if (done_counting) begin
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                    if (done && ack) begin
                        done <= 1'b0;
                    end
                end else begin
                    counting <= 1'b0;
                    shift_ena <= 1'b0;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule