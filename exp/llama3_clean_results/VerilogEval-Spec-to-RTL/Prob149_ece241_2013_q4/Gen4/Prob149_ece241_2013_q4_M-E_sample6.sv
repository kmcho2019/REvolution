module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] state;
reg [1:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        state <= 2'b11;
        prev_state <= 2'b11;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine next state
        case (s)
            3'b111: state <= 2'b00;
            3'b110, 3'b101, 3'b011: state <= 2'b01;
            3'b100, 3'b010, 3'b001: state <= 2'b10;
            default: state <= 2'b11;
        endcase

        // Output signal assignments
        case (state)
            2'b00: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b11: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase

        // Check for rising edge on sensor signals to assert dfr
        if (state > prev_state) begin
            dfr <= 1'b1;
        end
        prev_state <= state;
    end
end

endmodule