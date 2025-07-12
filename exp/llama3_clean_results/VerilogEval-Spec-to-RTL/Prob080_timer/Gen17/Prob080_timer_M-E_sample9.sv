module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] count;
reg [1:0] state; // 0: IDLE, 1: COUNTING, 2: TERMINAL_COUNT
reg [9:0] next_count;

always @(posedge clk)
begin
    case(state)
        2'b00: // IDLE
        begin
            if (load)
            begin
                count <= data;
                state <= 2'b01;
            end
            else
                state <= 2'b00;
        end
        2'b01: // COUNTING
        begin
            if (load)
            begin
                count <= data;
            end
            else if (count > 10'd0)
            begin
                count <= count - 1;
            end
            else
            begin
                state <= 2'b10;
            end
        end
        2'b10: // TERMINAL_COUNT
        begin
            if (load)
            begin
                count <= data;
                state <= 2'b01;
            end
            else
                state <= 2'b10;
        end
    endcase
end

assign tc = (state == 2'b10);

endmodule