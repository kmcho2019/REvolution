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

reg [3:0] state;
reg [3:0] detect;
reg [1:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
        detect <= 4'b0000;
        count <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            4'b0000: begin // IDLE
                detect[3:1] <= detect[2:0];
                detect[0] <= data;
                if (detect == 4'b1101) begin
                    state <= 4'b0001;
                    count <= 2'b00;
                end
            end
            4'b0001: begin // SHIFT
                shift_ena <= 1'b1;
                count <= count + 1'b1;
                if (count == 2'b11) begin
                    state <= 4'b0010;
                    counting <= 1'b1;
                end
            end
            4'b0010: begin // COUNT
                shift_ena <= 1'b0;
                if (done_counting) begin
                    state <= 4'b0011;
                    done <= 1'b1;
                end
            end
            4'b0011: begin // DONE
                counting <= 1'b0;
                if (ack) begin
                    state <= 4'b0000;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule