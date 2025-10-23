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
        state <= 0; // Idle
        done <= 0;
        count <= 0;
        data <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin
                    state <= 1; // Start
                end
            end
            1: begin // Start
                state <= 2; // Data
                count <= 1;
                data[0] <= in;
            end
            2: begin // Data
                if (count < 8) begin
                    count <= count + 1;
                    data[count-1] <= in;
                end else begin
                    state <= 3; // Stop
                end
            end
            3: begin // Stop
                if (in) begin
                    state <= 0; // Idle
                    done <= 1;
                end else begin
                    state <= 4; // Error
                end
            end
            4: begin // Error
                if (in) begin
                    state <= 0; // Idle
                end
            end
            default: begin
                state <= 0; // Idle
            end
        endcase
        if (state != 3) begin
            done <= 0;
        end
    end
end

endmodule