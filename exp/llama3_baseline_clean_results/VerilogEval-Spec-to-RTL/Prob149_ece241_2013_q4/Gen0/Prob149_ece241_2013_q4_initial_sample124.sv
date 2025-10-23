module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// FSM states
reg [1:0] state;

// Previous state
reg [1:0] prev_state;

// Initialize state to State 0 when reset
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine current state based on sensor inputs
        case (s)
            3'b000: state <= 2'b00;
            3'b001: state <= 2'b01;
            3'b011: state <= 2'b01;
            3'b010: state <= 2'b10;
            3'b110: state <= 2'b10;
            3'b111: state <= 2'b11;
            default: state <= state;
        endcase

        // Determine output flow rates based on current state and previous state
        case (state)
            2'b00: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == 2'b00) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_state == 2'b01) begin
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b11: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            default: begin
                fr2 <= fr2;
                fr1 <= fr1;
                fr0 <= fr0;
                dfr <= dfr;
            end
        endcase

        // Update previous state
        prev_state <= state;
    end
end

endmodule