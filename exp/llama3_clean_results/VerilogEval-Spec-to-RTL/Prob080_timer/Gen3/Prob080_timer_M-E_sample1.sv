module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // 0: idle, 1: countdown, 2: done
assign tc = (state == 2);

always @(posedge clk)
    case(state)
        0: begin // idle
            if (load) begin
                counter <= data;
                state <= 1;
            end else begin
                state <= 0;
            end
        end
        1: begin // countdown
            if (counter > 10'd0) begin
                counter <= counter - 1;
                state <= 1;
            end else begin
                state <= 2;
            end
        end
        2: begin // done
            if (load) begin
                counter <= data;
                state <= 1;
            end else begin
                state <= 2;
            end
        end
        default: state <= 0;
    endcase

endmodule