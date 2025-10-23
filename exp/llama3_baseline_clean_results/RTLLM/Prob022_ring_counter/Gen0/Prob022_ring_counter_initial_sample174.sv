module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;
reg [2:0] counter;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001; // Initialize to the starting state
        counter <= 0; // Reset the counter
    end else begin
        counter <= counter + 1; // Increment the counter on each clock cycle
        if (counter == 7) begin
            counter <= 0; // Wrap around to 0 after reaching 7
        end
        case (counter)
            0: state <= 8'b0000_0001;
            1: state <= 8'b0000_0010;
            2: state <= 8'b0000_0100;
            3: state <= 8'b0000_1000;
            4: state <= 8'b0001_0000;
            5: state <= 8'b0010_0000;
            6: state <= 8'b0100_0000;
            7: state <= 8'b1000_0000;
            default: state <= 8'b0000_0001; // Should not reach here
        endcase
    end
end

assign out = state;

endmodule