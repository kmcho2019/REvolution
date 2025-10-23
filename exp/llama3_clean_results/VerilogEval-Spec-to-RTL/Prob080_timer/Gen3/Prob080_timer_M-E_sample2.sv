module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state;
assign tc = (counter == 0)? 1'b1 : 1'b0;

always @(posedge clk) begin
    case(state)
        2'b00: // idle state
            begin
                if(load) begin
                    counter <= data;
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
        2'b01: // counting state
            begin
                if(counter > 0) begin
                    counter <= counter - 1;
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
        default: state <= 2'b00;
    endcase
end

endmodule