module TopModule(
    input           clk,
    input           reset,
    input           in,
    output          done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: DONE
reg [2:0] data_count; // Counter for data bits
reg [7:0] data; // Register to store the received data

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        data_count <= 0;
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // Start bit received
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_count <= 1'b1;
                data[0] <= in; // Store the least significant bit
            end
            2: begin // DATA
                data_count <= data_count + 1'b1;
                data[data_count - 1] <= in; // Store the current bit
                if (data_count == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit received
                    state <= 4; // DONE
                    done <= 1'b1;
                end
            end
            4: begin // DONE
                done <= 1'b0;
                state <= 0; // IDLE
            end
            default: state <= 0; // IDLE
        endcase
    end
end

endmodule