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
        count <= 3'b000;
        done <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (!in) begin
                    state <= 3'b001; // START
                    data <= 8'b00000000;
                    count <= 3'b000;
                end
            end
            3'b001: begin // START
                data[0] <= in;
                count <= count + 1'b1;
                if (count == 3'b1000) begin
                    state <= 3'b010; // DATA
                end
            end
            3'b010: begin // DATA
                data <= {data[6:0], in};
                count <= count + 1'b1;
                if (count == 3'b1000) begin
                    state <= 3'b011; // STOP
                end
            end
            3'b011: begin // STOP
                if (in) begin
                    out_byte <= data;
                    done <= 1'b1;
                    state <= 3'b000; // IDLE
                end
            end
            default: state <= 3'b000; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (!reset) begin
        if (state == 3'b011 && !in) begin
            // do nothing, wait for stop bit
        end else if (state == 3'b000 && in) begin
            done <= 1'b0;
        end
    end
end

endmodule