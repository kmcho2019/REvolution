module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Internal signals
reg [1:0] current_state;
reg [1:0] prev_state;

// Priority encoder to determine current state
always @(*) begin
    case (1'b1)
        s[2]: current_state = 2'b11; // Above highest sensor
        s[1]: current_state = 2'b10; // Between highest and middle sensor
        s[0]: current_state = 2'b01; // Between middle and lowest sensor
        default: current_state = 2'b00; // Below lowest sensor
    endcase
end

// Sequential logic to update current state and reset logic
always @(posedge clk) begin
    if (reset) begin
        prev_state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= current_state;
        
        // Determine output signals based on current state
        case (current_state)
            2'b11: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_state == 2'b00) ? 1'b1 : 1'b0;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state == 2'b00) ? 1'b1 : 1'b0;
            end
            2'b00: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_state != 2'b00) ? 1'b1 : 1'b0;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule