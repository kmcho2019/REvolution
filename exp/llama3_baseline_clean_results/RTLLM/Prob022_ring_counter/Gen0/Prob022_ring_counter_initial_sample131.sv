module ring_counter(
    input clk, 
    input reset, 
    output [7:0] out
);

reg [7:0] current_state;

initial current_state = 8'b0000_0001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 8'b0000_0001;
    end else begin
        current_state <= {current_state[6:0], current_state[7]};
    end
end

assign out = current_state;

endmodule