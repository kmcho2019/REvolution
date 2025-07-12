module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state;
reg [1:0] nextState;

always @(*) begin
    case (state)
        2'b00: begin // idle
            if (in[3]) begin
                nextState = 2'b01;
            end else begin
                nextState = 2'b00;
            end
        end
        2'b01: begin // byte1
            nextState = 2'b10;
        end
        2'b10: begin // byte2
            nextState = 2'b11;
        end
        2'b11: begin // byte3
            nextState = 2'b00;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
    end else begin
        state <= nextState;
        if (state == 2'b11) begin
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule