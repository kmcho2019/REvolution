module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] internal_count;
reg [1:0] state; // 0: Idle, 1: Load, 2: Counting
wire load_done;

assign tc = (state == 2'b10) && (internal_count == 10'd0);

always @(posedge clk)
begin
    case(state)
        2'b00: // Idle
            if(load)
                state <= 2'b01;
        2'b01: // Load
            begin
                internal_count <= data;
                if(data != 10'd0)
                    state <= 2'b10;
                else
                    state <= 2'b00;
            end
        2'b10: // Counting
            if(internal_count > 10'd0)
                internal_count <= internal_count - 1;
            else
                state <= 2'b00;
    endcase
end

endmodule