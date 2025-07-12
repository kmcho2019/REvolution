module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [1:0] state;
reg [2:0] bit_count;
reg [7:0] byte;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        bit_count <= 3'b000;
        byte <= 8'b00000000;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle
                if (!in) begin
                    state <= 2'b01;
                    bit_count <= 3'b001;
                    byte[0] <= 1'b0;
                end
            end
            2'b01: begin // Receive
                byte[bit_count] <= in;
                if (bit_count == 3'b100) begin
                    state <= 2'b10;
                end else begin
                    bit_count <= bit_count + 1'b1;
                end
            end
            2'b10: begin // Stop
                if (in) begin
                    out_byte <= byte;
                    done <= 1'b1;
                    state <= 2'b00;
                    bit_count <= 3'b000;
                end else begin
                    state <= 2'b11; // Error
                end
            end
            2'b11: begin // Error
                if (in) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (state == 2'b10 && in) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule