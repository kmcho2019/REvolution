module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] state;
reg [3:0] delay;
reg [3:0] counter;
reg [9:0] internal_count;
reg [3:0] current_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000; // IDLE
        delay <= 4'b0000;
        counter <= 4'b0000;
        internal_count <= 10'b0000000000;
        current_count <= 4'b0000;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            4'b0000: begin // IDLE
                if (data == 1'b1) begin
                    state <= 4'b0001;
                end
            end
            4'b0001: begin // searching for 1101
                if (data == 1'b0) begin
                    state <= 4'b0010;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0010: begin // searching for 1101
                if (data == 1'b0) begin
                    state <= 4'b0011;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0011: begin // searching for 1101
                if (data == 1'b1) begin
                    state <= 4'b0100;
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0100: begin // searching for 1101
                if (data == 1'b1) begin
                    state <= 4'b0101; // start shifting delay bits
                end else begin
                    state <= 4'b0000;
                end
            end
            4'b0101: begin // shifting delay bits
                delay[3] <= data;
                state <= 4'b0110;
            end
            4'b0110: begin // shifting delay bits
                delay[2] <= data;
                state <= 4'b0111;
            end
            4'b0111: begin // shifting delay bits
                delay[1] <= data;
                state <= 4'b1000;
            end
            4'b1000: begin // shifting delay bits
                delay[0] <= data;
                state <= 4'b1001; // start counting
                current_count <= delay + 1;
                internal_count <= 10'b0000000000;
                counting <= 1'b1;
            end
            4'b1001: begin // counting
                internal_count <= internal_count + 1'b1;
                if (internal_count == 10'b1111101000) begin
                    internal_count <= 10'b0000000000;
                    if (current_count > 1'b0) begin
                        current_count <= current_count - 1'b1;
                    end else begin
                        state <= 4'b1010; // done
                        done <= 1'b1;
                        counting <= 1'b0;
                    end
                end
            end
            4'b1010: begin // done
                if (ack == 1'b1) begin
                    state <= 4'b0000; // reset
                    done <= 1'b0;
                end
            end
        endcase
    end
end

assign count = current_count;

endmodule