module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: searching, 1: byte1, 2: byte2
reg [1:0] counter; // counter for bytes received after first byte

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // searching for first byte
                if (in[3]) begin
                    state <= 1;
                    counter <= 1;
                end
            end
            1: begin // received first byte
                counter <= counter + 1;
                state <= 2;
            end
            2: begin // received second byte
                counter <= counter + 1;
                if (counter == 3) begin
                    state <= 0;
                    done <= 1;
                end else begin
                    state <= 2;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (!reset) begin
        if (state != 2 || counter != 3) begin
            done <= 0;
        end
    end
end

endmodule