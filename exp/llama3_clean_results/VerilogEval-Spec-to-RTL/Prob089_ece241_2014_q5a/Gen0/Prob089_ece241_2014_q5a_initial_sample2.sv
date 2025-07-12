module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state = 2'b00; // 2'b00: idle, 2'b01: calculate, 2'b10: add_one
reg [31:0] num = 32'd0; // to store the input number
reg [31:0] temp = 32'd0; // temporary register to calculate 2's complement
reg add_one = 1'b0; // flag to add 1

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
        num <= 32'd0;
        temp <= 32'd0;
        add_one <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // idle state
                if (~areset) begin
                    state <= 2'b01;
                    num <= 32'd0;
                    temp <= 32'd0;
                    add_one <= 1'b0;
                end
            end
            2'b01: begin // calculate state
                num <= {num[30:0], x}; // shift left and add new bit
                if (x) begin
                    add_one <= 1'b1; // if input bit is 1, set add_one flag
                end
                if (areset) begin // if reset is asserted, go back to idle
                    state <= 2'b00;
                    num <= 32'd0;
                    temp <= 32'd0;
                    add_one <= 1'b0;
                end
            end
            default: state <= 2'b00;
        endcase
        
        // calculate 2's complement
        temp <= ~num;
        
        // add 1 if necessary
        if (add_one) begin
            temp <= temp + 1'b1;
        end
        
        // output the least significant bit of the 2's complement
        z <= temp[0];
    end
end

endmodule