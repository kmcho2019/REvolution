module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // 0: IDLE, 1: COUNTING, 2: TERMINAL_COUNT

always @(posedge clk) begin
    case (state)
        0: begin // IDLE
            if (load) begin
                counter <= data;
                state <= 1;
            end
        end
        1: begin // COUNTING
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= 2;
            end
        end
        2: begin // TERMINAL_COUNT
            if (load) begin
                counter <= data;
                state <= 1;
            end
        end
        default: begin
            state <= 0;
        end
    endcase
end

assign tc = (state == 2);

endmodule