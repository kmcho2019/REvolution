module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // 0: idle, 1: counting, 2: terminal_count

always @(posedge clk)
    case (state)
        2'b00: // idle
            begin
                if (load)
                    begin
                        counter <= data;
                        state <= 2'b01;
                    end
            end
        2'b01: // counting
            begin
                if (counter == 10'd0)
                    state <= 2'b10;
                else
                    counter <= counter - 1;
            end
        2'b10: // terminal_count
            begin
                if (load)
                    begin
                        counter <= data;
                        state <= 2'b01;
                    end
            end
    endcase

assign tc = (state == 2'b10);

endmodule