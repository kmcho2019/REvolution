module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

wire [1:0] next_state;

// Next state logic using continuous assignment
assign next_state = areset ? 2'b01 : 
                   (train_valid ? 
                       (train_taken ? 
                           (state == 2'b11 ? 2'b11 : state + 1'b1) : 
                           (state == 2'b00 ? 2'b00 : state - 1'b1)) : 
                       state);

// Sequential state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else begin
        state <= next_state;
    end
end

endmodule