module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: Reset, 1: First bit, 2: Normal operation
reg [31:0] counter; // Counter for the number of bits processed
reg sign; // Sign of the input number
reg [31:0] result; // Result of the 2's complement operation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        counter <= 0;
        sign <= 0;
        result <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Reset state
                if (~areset) begin
                    state <= 1;
                end
            end
            1: begin // First bit state
                sign <= x;
                result[0] <= x;
                counter <= 1;
                state <= 2;
            end
            2: begin // Normal operation state
                if (sign) begin
                    result[counter] <= ~x;
                end else begin
                    result[counter] <= x;
                end
                counter <= counter + 1;
                if (areset) begin
                    state <= 0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~areset && (state == 2)) begin
        z <= result[counter - 1];
    end else begin
        z <= 0;
    end
end

endmodule