module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // idle, converting, done
reg [31:0] count; // counter to keep track of input bits
reg [31:0] result; // result of 2's complement calculation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // idle
        count <= 0;
        result <= 0;
        z <= 0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (x) begin
                    state <= 2'b01; // converting
                    count <= 1;
                    result <= ~x;
                    z <= ~x;
                end else begin
                    z <= 0;
                end
            end
            2'b01: begin // converting
                count <= count + 1;
                result <= {result[30:0], ~x};
                z <= ~x;
                if (count == 32) begin // assuming 32-bit input
                    state <= 2'b10; // done
                end
            end
            2'b10: begin // done
                z <= result[0];
            end
        endcase
    end
end

endmodule