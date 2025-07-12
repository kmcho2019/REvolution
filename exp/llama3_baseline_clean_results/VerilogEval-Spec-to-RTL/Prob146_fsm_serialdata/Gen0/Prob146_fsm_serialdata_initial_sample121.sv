module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] data;
reg [2:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        done <= 0;
        out_byte <= 8'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (!in) begin
                    state <= 3'b001; // START
                    count <= 3'b000;
                end
            end
            3'b001: begin // START
                state <= 3'b010; // DATA
                count <= 3'b000;
            end
            3'b010: begin // DATA
                data[count] <= in;
                count <= count + 1;
                if (count == 7) begin
                    state <= 3'b011; // STOP
                end
            end
            3'b011: begin // STOP
                if (in) begin
                    state <= 3'b100; // DONE
                    out_byte <= {1'b0, data[6:0], in};
                    done <= 1;
                end else begin
                    state <= 3'b000; // IDLE
                end
            end
            3'b100: begin // DONE
                done <= 0;
                if (in) begin
                    state <= 3'b000; // IDLE
                end
            end
            default: begin
                state <= 3'b000; // IDLE
            end
        endcase
    end
end

endmodule