module ring_counter(
    input clk, 
    input reset, 
    output [7:0] out
);

reg [2:0] state; // 3 bits can represent 8 states (0 to 7)
reg [7:0] output;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // Reset state to 0
    end else begin
        state <= (state + 1) % 8; // Increment state and wrap around to 0 after 7
    end
end

always @ (*) begin
    case (state)
        0: output = 8'b0000_0001;
        1: output = 8'b0000_0010;
        2: output = 8'b0000_0100;
        3: output = 8'b0000_1000;
        4: output = 8'b0001_0000;
        5: output = 8'b0010_0000;
        6: output = 8'b0100_0000;
        7: output = 8'b1000_0000;
        default: output = 8'b0000_0001;
    endcase
    out = output;
end

endmodule