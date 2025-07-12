module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // 0: idle, 1: counting, 2: done
reg [1:0] next_state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // idle
            if (load) begin
                counter <= data;
                state <= 2'b00;
            end else begin
                state <= 2'b01;
            end
        end
        2'b01: begin // counting
            if (counter > 0) begin
                counter <= counter - 1;
                state <= 2'b01;
            end else begin
                state <= 2'b10;
            end
        end
        2'b10: begin // done
            state <= 2'b10;
        end
    endcase
end

assign tc = (state == 2'b10);

endmodule