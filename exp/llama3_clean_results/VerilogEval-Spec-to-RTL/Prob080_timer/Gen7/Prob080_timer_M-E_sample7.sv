module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state;
parameter IDLE = 2'b00, COUNTING = 2'b01;

always @(posedge clk) begin
    case(state)
        IDLE: begin
            if(load) begin
                counter <= data;
                state <= COUNTING;
            end
        end
        COUNTING: begin
            if(counter!= 0) begin
                counter <= counter - 1;
            end else begin
                state <= IDLE;
            end
        end
    endcase
end

assign tc = (state == IDLE && counter == 0)? 1'b1 : 1'b0;

endmodule