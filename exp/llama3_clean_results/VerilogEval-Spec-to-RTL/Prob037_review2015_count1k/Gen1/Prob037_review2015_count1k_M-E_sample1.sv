module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

reg [9:0] counter_value;
reg [1:0] state;

always @(posedge clk) begin
    case (state)
        2'b00: begin // idle state
            if (reset) begin
                state <= 2'b01; // transition to reset state
                counter_value <= 10'd0;
            end else if (counter_value == 10'd999) begin
                counter_value <= 10'd0;
            end else begin
                counter_value <= counter_value + 10'd1;
            end
        end
        2'b01: begin // reset state
            state <= 2'b00; // transition back to idle state
            counter_value <= 10'd0;
        end
        default: begin
            state <= 2'b00; // default to idle state
            counter_value <= 10'd0;
        end
    endcase
end

assign q = counter_value;

endmodule