module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [1:0] state;
reg [7:0] data;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE state
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (!in) begin // start bit detected
                    state <= 2'b01; // START state
                end
                done <= 1'b0;
            end
            2'b01: begin // START state
                state <= 2'b10; // DATA state
            end
            2'b10: begin // DATA state
                data <= {data[6:0], in}; // shift in data bit
                if (data[7] == 1'b1) begin // all data bits collected
                    state <= 2'b11; // STOP state
                end
                done <= 1'b0;
            end
            2'b11: begin // STOP state
                if (in) begin // stop bit detected
                    out_byte <= data;
                    done <= 1'b1;
                    state <= 2'b00; // IDLE state
                end else begin
                    state <= 2'b11; // wait for stop bit
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

endmodule