module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state; // 4-bit state register to track sequence
initial state = 4'b0000; // Initialize to 0

always @(posedge clk) begin
    if(reset) begin
        state <= 4'b0000;
        start_shifting <= 0;
    end else begin
        case(state)
            4'b0000: state <= data? 4'b0001 : 4'b0000;
            4'b0001: state <= data? 4'b0011 : 4'b0000;
            4'b0011: state <= data? 4'b0111 : 4'b0001;
            4'b0111: state <= data? 4'b1111 : 4'b0000;
            4'b1111: state <= 4'b1111; // Stay in this state once sequence is found
            default: state <= 4'b0000;
        endcase
        if(state == 4'b1111) start_shifting <= 1;
        else if(reset) start_shifting <= 0;
    end
end

endmodule