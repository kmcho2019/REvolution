module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter; // 5-bit counter to index the LUT
reg incr; // Flag to indicate whether to increment or decrement the counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        incr <= 1; // Start by incrementing
    end else begin
        if (incr) begin // Incrementing phase
            counter <= counter + 1;
            if (counter == 31) begin
                incr <= 0; // Switch to decrementing phase
            end
        end else begin // Decrementing phase
            counter <= counter - 1;
            if (counter == 0) begin
                incr <= 1; // Switch back to incrementing phase
            end
        end
    end
end

always @(*) begin
    case (counter)
        5'b00000: wave = 5'b00000;
        5'b00001: wave = 5'b00001;
        5'b00010: wave = 5'b00010;
        5'b00011: wave = 5'b00011;
        5'b00100: wave = 5'b00100;
        5'b00101: wave = 5'b00101;
        5'b00110: wave = 5'b00110;
        5'b00111: wave = 5'b00111;
        5'b01000: wave = 5'b01000;
        5'b01001: wave = 5'b01001;
        5'b01010: wave = 5'b01010;
        5'b01011: wave = 5'b01011;
        5'b01100: wave = 5'b01100;
        5'b01101: wave = 5'b01101;
        5'b01110: wave = 5'b01110;
        5'b01111: wave = 5'b01111;
        5'b10000: wave = 5'b10000;
        5'b10001: wave = 5'b10001;
        5'b10010: wave = 5'b10010;
        5'b10011: wave = 5'b10011;
        5'b10100: wave = 5'b10100;
        5'b10101: wave = 5'b10101;
        5'b10110: wave = 5'b10110;
        5'b10111: wave = 5'b10111;
        5'b11000: wave = 5'b11000;
        5'b11001: wave = 5'b11001;
        5'b11010: wave = 5'b11010;
        5'b11011: wave = 5'b11011;
        5'b11100: wave = 5'b11100;
        5'b11101: wave = 5'b11101;
        5'b11110: wave = 5'b11110;
        5'b11111: wave = 5'b11111;
        default: wave = 5'b00000;
    endcase
end

endmodule