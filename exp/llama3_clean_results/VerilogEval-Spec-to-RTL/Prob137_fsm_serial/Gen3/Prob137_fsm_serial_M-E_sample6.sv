module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

reg [1:0] state;
reg [1:0] nextState;
reg [7:0] dataBits;
reg [3:0] dataBitCount;

always @(*) begin
    case(state)
        2'b00: // IDLE
            if (!in) begin
                nextState = 2'b01; // START
            end else begin
                nextState = 2'b00; // IDLE
            end
        2'b01: // START
            if (dataBitCount == 8) begin
                nextState = 2'b10; // STOP
            end else begin
                nextState = 2'b01; // START
            end
        2'b10: // STOP
            if (in) begin
                nextState = 2'b00; // IDLE
                done = 1'b1;
            end else begin
                nextState = 2'b11; // ERROR
            end
        2'b11: // ERROR
            if (in) begin
                nextState = 2'b00; // IDLE
            end else begin
                nextState = 2'b11; // ERROR
            end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        dataBitCount <= 4'b0;
        dataBits <= 8'b0;
        done <= 1'b0;
    end else begin
        state <= nextState;
        case(state)
            2'b01: // START
                dataBits[7-dataBitCount] <= in;
                dataBitCount <= dataBitCount + 1'b1;
            2'b11: // ERROR
                if (in) begin
                    dataBitCount <= 4'b0;
                end
        endcase
    end
end

endmodule