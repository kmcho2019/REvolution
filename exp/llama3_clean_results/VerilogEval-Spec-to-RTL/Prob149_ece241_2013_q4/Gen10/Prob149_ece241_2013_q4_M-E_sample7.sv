module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Define the different states of the water level
enum logic [1:0] {S ABOVE, S_MIDDLE, S_BELOW} state;

reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S_BELOW;
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update the previous sensor values
        prev_s <= s;

        // Determine the current state
        case (s)
            3'b111: state <= S_ABOVE;
            3'b110, 3'b101, 3'b011: state <= S_MIDDLE;
            default: state <= S_BELOW;
        endcase

        // Set the flow rates based on the current state
        case (state)
            S_ABOVE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            S_MIDDLE: begin
                fr2 <= 1'b0;
                fr1 <= (s[1] || s[0]);
                fr0 <= (s[0]);
                dfr <= ((s[1] || s[0]) && !(prev_s[1] || prev_s[0]));
            end
            S_BELOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule