module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state;
reg [7:0] data;
reg [3:0] bit_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_count <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                    bit_count <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                data[bit_count] <= in; // collect data bits
                if (bit_count == 7) begin
                    state <= 3; // STOP
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit verified
                    done <= 1;
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

always @(negedge clk) begin
    done <= 0; // clear done flag
end

endmodule