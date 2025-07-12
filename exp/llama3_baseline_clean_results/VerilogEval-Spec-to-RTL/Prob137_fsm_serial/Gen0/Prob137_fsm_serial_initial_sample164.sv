module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

reg [2:0] state;
reg [7:0] data;
reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        count <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1; // START
                    count <= 0;
                    data <= 8'b0;
                end
            end
            1: begin // START
                state <= 2; // DATA
                count <= 1;
                data[0] <= in;
            end
            2: begin // DATA
                data[count] <= in;
                count <= count + 1;
                if (count == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin
                    done <= 1;
                    state <= 0; // IDLE
                end else begin
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin
                    state <= 0; // IDLE
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

always @(negedge clk) begin
    if (done) begin
        done <= 0;
    end
end

endmodule