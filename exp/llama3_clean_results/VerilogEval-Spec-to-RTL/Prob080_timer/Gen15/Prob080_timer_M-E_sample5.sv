module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg tc_reg;
reg [1:0] state; // 0: idle, 1: loading, 2: counting

always @(posedge clk)
begin
    case (state)
        2'b00: // idle
        begin
            if (load)
                state <= 2'b01;
            tc_reg <= 1'b0;
        end
        2'b01: // loading
        begin
            counter <= data;
            state <= 2'b10;
        end
        2'b10: // counting
        begin
            if (counter > 10'd0)
                counter <= counter - 1;
            else
            begin
                tc_reg <= 1'b1;
                state <= 2'b00;
            end
        end
    endcase
end

assign tc = tc_reg;

endmodule