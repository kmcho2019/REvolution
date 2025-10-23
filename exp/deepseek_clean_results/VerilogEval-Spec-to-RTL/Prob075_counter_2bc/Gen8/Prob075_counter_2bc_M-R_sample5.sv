module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    state <= areset ? 2'b01 : 
             train_valid ? (train_taken ? (state == 2'b11 ? 2'b11 : state + 1) : 
                                       (state == 2'b00 ? 2'b00 : state - 1)) : 
             state;
end

endmodule