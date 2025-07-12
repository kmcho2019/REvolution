module TopModule(
    input  clk,
    input  in,
    input  reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [2:0] nextState;
reg [7:0] data;
reg [2:0] bit_count;

always @(*) begin
    case (state)
        3'b000: begin // IDLE
            if (in == 1'b0) begin
                nextState = 3'b001; // START
                done = 1'b0;
            end else begin
                nextState = 3'b000; // IDLE
                done = 1'b0;
            end
        end
        3'b001: begin // START
            nextState = 3'b010; // DATA
            done = 1'b0;
        end
        3'b010: begin // DATA
            if (bit_count == 3'b111) begin
                nextState = 3'b011; // STOP
                done = 1'b0;
            end else begin
                nextState = 3'b010; // DATA
                done = 1'b0;
            end
        end
        3'b011: begin // STOP
            if (in == 1'b1) begin
                nextState = 3'b000; // IDLE
                done = 1'b1;
            end else begin
                nextState = 3'b011; // STOP
                done = 1'b0;
            end
        end
        default: begin
            nextState = 3'b000; // IDLE
            done = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        bit_count <= 3'b000;
        out_byte <= 8'b0;
    end else begin
        state <= nextState;
        if (state == 3'b010) begin // DATA
            data[bit_count] = in;
            bit_count <= bit_count + 1'b1;
            if (bit_count == 3'b111) begin
                out_byte <= {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
            end
        end else if (state == 3'b011) begin // STOP
            bit_count <= 3'b000;
            data <= 8'b0;
        end else begin
            bit_count <= 3'b000;
            data <= 8'b0;
        end
    end
end

endmodule