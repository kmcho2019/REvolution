module TopModule(
    input clk,
    input reset,
    input data,
    output start_shifting
);

reg [1:0] state; // 2-bit state variable
reg start_shifting_reg;

always @ (posedge clk) begin
    if(reset) begin
        state <= 2'b00; // idle state
        start_shifting_reg <= 0;
    end
    else begin
        case(state)
            2'b00: begin // idle state
                if(data == 1'b1) begin
                    state <= 2'b01; // got_1 state
                end
            end
            2'b01: begin // got_1 state
                if(data == 1'b1) begin
                    state <= 2'b10; // got_11 state
                end
                else begin
                    state <= 2'b00; // back to idle state
                end
            end
            2'b10: begin // got_11 state
                if(data == 1'b0) begin
                    state <= 2'b11; // got_110 state
                end
                else begin
                    state <= 2'b01; // back to got_1 state
                end
            end
            2'b11: begin // got_110 state
                if(data == 1'b1) begin
                    start_shifting_reg <= 1'b1;
                end
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule