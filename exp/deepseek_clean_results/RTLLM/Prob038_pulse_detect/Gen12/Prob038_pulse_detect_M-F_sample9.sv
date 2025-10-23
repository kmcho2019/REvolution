module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // [previous, current]

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new value
        state <= {state[0], data_in};
        
        // Detect falling edge after high pulse
        data_out <= (state == 2'b10) && (data_in == 1'b0);
    end
end

endmodule