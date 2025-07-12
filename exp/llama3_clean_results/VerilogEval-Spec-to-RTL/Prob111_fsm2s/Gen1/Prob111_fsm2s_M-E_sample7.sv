module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [1:0] state; // 2-bit signal to represent the current state
reg [1:0] next_state; // 2-bit signal to represent the next state

localparam OFF = 2'b00; // OFF state
localparam ON = 2'b01; // ON state

always @(*) begin
    case({state, j, k})
        {OFF, 1'b0, 1'b0}, {OFF, 1'b0, 1'b1}, {OFF, 1'b1, 1'b0}: next_state = OFF;
        {OFF, 1'b1, 1'b1}: next_state = ON;
        {ON, 1'b0, 1'b0}, {ON, 1'b0, 1'b1}: next_state = ON;
        {ON, 1'b1, 1'b0}, {ON, 1'b1, 1'b1}: next_state = OFF;
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        state <= OFF; // reset to OFF state
    end else begin
        state <= next_state;
    end
end

assign out = (state == ON) ? 1'b1 : 1'b0; // output is the current state

endmodule